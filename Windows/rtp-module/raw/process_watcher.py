import sys
import json
import os
import queue
import threading
import time
import psutil
import win32com.client
from pathlib import Path

def _now():
    return time.strftime("%Y-%m-%d %H:%M:%S")


def _base_dir() -> Path:
    if getattr(sys, "frozen", False) and hasattr(sys, "executable"):
        return Path(sys.executable).resolve().parent
    return Path(__file__).resolve().parent


def _logs_dir() -> Path:
    return _base_dir() / "rtp_logs"


def _detections_dir() -> Path:
    return _logs_dir() / "detections"


def _ensure_dirs():
    try:
        _logs_dir().mkdir(parents=True, exist_ok=True)
        _detections_dir().mkdir(parents=True, exist_ok=True)
    except Exception:
        pass


def _write_json_atomic(path: Path, obj: dict):
    try:
        tmp = path.with_suffix(path.suffix + ".tmp")
        tmp.write_text(json.dumps(obj, ensure_ascii=False), encoding="utf-8")
        os.replace(str(tmp), str(path))
    except Exception:
        pass


def _write_detection(obj: dict):
    try:
        _ensure_dirs()
        ts = obj.get("ts") or int(time.time() * 1000)
        pid = obj.get("pid") or 0
        name = obj.get("name") or ""
        safe_name = "".join(c for c in name if c.isalnum() or c in ("-", "_"))[:40]
        fname = f"{ts}_{pid}_{safe_name}.json"
        path = _detections_dir() / fname
        _write_json_atomic(path, obj)
    except Exception:
        pass


def _proc_stream_max():
    try:
        return int(os.environ.get("CS_PROC_STREAM_MAX", "200") or "200")
    except Exception:
        return 200


def _is_malicious(verdict: dict) -> bool:
    v = str(verdict.get("verdict", "")).lower()
    if v in ("malicious", "malware", "infected", "bad", "deny", "block"):
        return True
    if "malware" in v or "infect" in v:
        return True
    raw = str(verdict.get("raw", "")).lower()
    if "malicious" in raw or "malware" in raw or "infected" in raw:
        return True
    return False


def _terminate_pid(pid: int) -> bool:
    try:
        p = psutil.Process(pid)
        p.terminate()
        try:
            p.wait(timeout=2)
            return True
        except Exception:
            pass
        p.kill()
        try:
            p.wait(timeout=2)
            return True
        except Exception:
            return False
    except Exception:
        return False


def _safe_str(x):
    try:
        return str(x)
    except Exception:
        return ""


def snapshot_processes():
    procs = {}
    for p in psutil.process_iter(["pid", "ppid", "name", "exe", "cmdline", "create_time", "username"]):
        try:
            info = p.info
            pid = int(info.get("pid") or 0)
            if pid <= 0:
                continue
            procs[pid] = {
                "pid": pid,
                "ppid": int(info.get("ppid") or 0),
                "name": _safe_str(info.get("name") or ""),
                "exe": _safe_str(info.get("exe") or ""),
                "cmdline": " ".join(info.get("cmdline") or []),
                "create_time": float(info.get("create_time") or 0.0),
                "username": _safe_str(info.get("username") or ""),
            }
        except Exception:
            continue
    return procs


class ProcessRtp:
    def __init__(self, snapshot_interval_s: float = 5.0, scan_client=None):
        self.snapshot_interval_s = snapshot_interval_s
        self.scan_client = scan_client
        self.q = queue.Queue()
        self.stop_evt = threading.Event()
        self.known_pids = {}
        self.seen_exec = set()
        self.stream_max = _proc_stream_max()
        self.user_started_pids = set()

    def start(self):
        _ensure_dirs()

        ready = bool(self.scan_client and self.scan_client.ready())
        if not ready:
            print(f"[{_now()}] scan client not ready", flush=True)
            _write_json_atomic(
                _logs_dir() / "status.json",
                {
                    "ts": int(time.time() * 1000),
                    "time": _now(),
                    "count": 0,
                    "shown": 0,
                    "processes": [],
                    "ready": False,
                    "reason": "scan_client_not_ready",
                },
            )
            return

        base = snapshot_processes()
        self.known_pids = base
        print(f"[{_now()}] baseline processes: {len(base)}", flush=True)
        self._emit_snapshot_stream(base, "baseline")

        threading.Thread(target=self._scan_worker, daemon=True).start()
        threading.Thread(target=self._snapshot_loop, daemon=True).start()
        threading.Thread(target=self._wmi_loop, daemon=True).start()

        try:
            while True:
                time.sleep(0.5)
        except KeyboardInterrupt:
            pass
        finally:
            self.stop_evt.set()
            time.sleep(0.5)

    def _is_system_account(self, username: str) -> bool:
        u = (username or "").lower()
        if not u:
            return True
        if u.startswith("nt authority\\"):
            return True
        if u.startswith("nt service\\"):
            return True
        if u.endswith("\\system"):
            return True
        return False

    def _should_track_new_proc(self, pid: int, info: dict) -> bool:
        exe = (info.get("exe") or "").strip()
        name = (info.get("name") or "").strip().lower()
        username = (info.get("username") or "").strip()

        if not exe:
            return False

        if self._is_system_account(username):
            return False

        if name in ("system", "idle", "registry", "memory compression"):
            return False

        ppid = int(info.get("ppid") or 0)
        parent = self.known_pids.get(ppid) or {}
        parent_name = (parent.get("name") or "").strip().lower()
        if parent_name in ("services.exe", "svchost.exe", "wininit.exe", "smss.exe", "csrss.exe", "winlogon.exe", "lsass.exe"):
            return False

        return True

    def _emit_snapshot_stream(self, snapshot: dict, stage: str):
        current = []
        for pid in sorted(self.user_started_pids):
            info = snapshot.get(pid)
            if not info:
                continue
            current.append(
                {
                    "pid": int(pid),
                    "name": info.get("name") or "",
                    "exe": info.get("exe") or "",
                }
            )

        current.sort(key=lambda x: (x["name"].lower(), x["pid"]))
        total = len(current)
        if self.stream_max > 0:
            current = current[: self.stream_max]

        payload = {
            "type": "proc_snapshot",
            "ts": int(time.time() * 1000),
            "time": _now(),
            "stage": stage,
            "count": total,
            "shown": len(current),
            "processes": current,
        }
        print(json.dumps(payload, ensure_ascii=False), flush=True)

        status = {
            "ts": payload["ts"],
            "time": payload["time"],
            "count": payload["count"],
            "shown": payload["shown"],
            "processes": payload["processes"],
        }
        _write_json_atomic(_logs_dir() / "status.json", status)

    def _enqueue(self, pid: int, exe_path: str, source: str):
        exe_path = exe_path or ""
        key = exe_path.lower()
        if key:
            if key in self.seen_exec:
                return
            self.seen_exec.add(key)
        self.q.put({"pid": pid, "exe": exe_path, "source": source})

    def _snapshot_loop(self):
        while not self.stop_evt.is_set():
            cur = snapshot_processes()
            cur_pids = set(cur.keys())
            old_pids = set(self.known_pids.keys())

            started = cur_pids - old_pids
            ended = old_pids - cur_pids

            for pid in sorted(started):
                info = cur.get(pid) or {}
                exe = info.get("exe") or ""
                name = info.get("name") or ""
                print(f"[{_now()}] started(pid={pid}) {name} {exe}", flush=True)

                if self._should_track_new_proc(pid, info):
                    self.user_started_pids.add(pid)
                    if exe:
                        self._enqueue(pid, exe, "snapshot")

            for pid in sorted(ended):
                info = self.known_pids.get(pid) or {}
                name = info.get("name") or ""
                exe = info.get("exe") or ""
                print(f"[{_now()}] ended(pid={pid}) {name} {exe}", flush=True)

                if pid in self.user_started_pids:
                    self.user_started_pids.discard(pid)

            self.known_pids = cur
            self._emit_snapshot_stream(cur, "tick")
            time.sleep(self.snapshot_interval_s)

    def _wmi_loop(self):
        try:
            locator = win32com.client.Dispatch("WbemScripting.SWbemLocator")
            svc = locator.ConnectServer(".", "root\\cimv2")
            svc.Security_.ImpersonationLevel = 3
            query = "SELECT * FROM __InstanceCreationEvent WITHIN 1 WHERE TargetInstance ISA 'Win32_Process'"
            watcher = svc.ExecNotificationQuery(query)
        except Exception as e:
            print(f"[{_now()}] wmi init failed: {e}", flush=True)
            return

        while not self.stop_evt.is_set():
            try:
                evt = watcher.NextEvent(1000)
                if not evt:
                    continue
                proc = evt.TargetInstance
                pid = int(proc.ProcessId)
                exe = _safe_str(getattr(proc, "ExecutablePath", "") or "")
                name = _safe_str(getattr(proc, "Name", "") or "")
                print(f"[{_now()}] created(pid={pid}) {name} {exe}", flush=True)

                info = {
                    "pid": pid,
                    "ppid": int(getattr(proc, "ParentProcessId", 0) or 0),
                    "name": name,
                    "exe": exe,
                    "username": "",
                }

                try:
                    p = psutil.Process(pid)
                    try:
                        info["username"] = _safe_str(p.username() or "")
                    except Exception:
                        info["username"] = ""
                except Exception:
                    pass

                if self._should_track_new_proc(pid, info):
                    self.user_started_pids.add(pid)
                    if exe:
                        self._enqueue(pid, exe, "wmi")
            except Exception:
                continue

    def _scan_worker(self):
        while not self.stop_evt.is_set():
            try:
                item = self.q.get(timeout=0.5)
            except queue.Empty:
                continue

            pid = int(item.get("pid") or 0)
            exe = item.get("exe") or ""
            source = item.get("source") or ""

            verdict = self.scan_client.scan_path(exe) if exe else {"verdict": "unknown", "reason": "no_exe_path"}
            bad = _is_malicious(verdict)

            if bad and pid > 0:
                stopped = _terminate_pid(pid)
                print(f"[{_now()}] MALICIOUS source={source} pid={pid} exe={exe} stopped={stopped} verdict={verdict}", flush=True)

                det = {
                    "type": "rtp_detection",
                    "ts": int(time.time() * 1000),
                    "time": _now(),
                    "pid": pid,
                    "exe": exe,
                    "source": source,
                    "stopped": bool(stopped),
                    "verdict": verdict,
                    "name": (os.path.basename(exe) if exe else ""),
                }
                _write_detection(det)
            else:
                print(f"[{_now()}] ok source={source} pid={pid} exe={exe} verdict={verdict}", flush=True)

            self.q.task_done()