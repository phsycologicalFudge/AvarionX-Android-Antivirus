import json
import os
import subprocess
import sys
import msvcrt
import tempfile
import threading
import time
from pathlib import Path

import download_watcher
from process_watcher import ProcessRtp


def _acquire_single_instance():
    lock_path = Path(tempfile.gettempdir()) / "avarionx_rtp.lock"
    f = open(lock_path, "w")
    try:
        msvcrt.locking(f.fileno(), msvcrt.LK_NBLCK, 1)
    except OSError:
        return None
    return f


def _now():
    return time.strftime("%Y-%m-%d %H:%M:%S")


def _self_dir() -> Path:
    if getattr(sys, "frozen", False) and hasattr(sys, "executable"):
        return Path(sys.executable).resolve().parent
    return Path(__file__).resolve().parent


def _find_root_dir() -> Path:
    start = _self_dir()
    for p in (start, *start.parents):
        if (p / "assets" / "defs" / "defs.vxpack").exists():
            return p
    return start


def _resolve_paths():
    self_dir = _self_dir()
    root_dir = _find_root_dir()

    engine = self_dir / "csav.exe"
    defs = root_dir / "assets" / "defs" / "defs.vxpack"
    key = root_dir / "assets" / "defs" / "defs_key.bin"

    return root_dir, self_dir, engine, defs, key


def _setup_file_logging(base_dir: Path):
    log_dir = base_dir / "rtp_logs"
    log_dir.mkdir(parents=True, exist_ok=True)
    f = open(log_dir / "rtp_main.log", "a", encoding="utf-8", buffering=1)
    sys.stdout = f
    sys.stderr = f
    

class ScanClient:
    def __init__(self, engine_path: Path, defs_path: Path, key_path: Path):
        self.engine_path = engine_path
        self.defs_path = defs_path
        self.key_path = key_path

    def ready(self) -> bool:
        return (
            self.engine_path.exists()
            and self.defs_path.exists()
            and self.key_path.exists()
        )

    def scan_path(self, scan_path: str) -> dict:
        if not self.ready():
            return {
                "verdict": "error",
                "reason": "engine_or_defs_missing",
                "engine": str(self.engine_path),
                "defs": str(self.defs_path),
                "key": str(self.key_path),
            }

        try:
            creationflags = 0
            startupinfo = None

            if os.name == "nt":
                creationflags = subprocess.CREATE_NO_WINDOW
                startupinfo = subprocess.STARTUPINFO()
                startupinfo.dwFlags |= subprocess.STARTF_USESHOWWINDOW

            p = subprocess.run(
                [
                    str(self.engine_path),
                    str(self.defs_path),
                    str(scan_path),
                    "--key",
                    str(self.key_path),
                ],
                capture_output=True,
                text=True,
                timeout=120,
                creationflags=creationflags,
                startupinfo=startupinfo,
            )
            out = (p.stdout or "").strip()
            err = (p.stderr or "").strip()

            if out:
                try:
                    return json.loads(out)
                except Exception:
                    return {
                        "verdict": "unknown",
                        "raw": out,
                        "stderr": err,
                        "code": p.returncode,
                    }

            if err:
                return {"verdict": "error", "stderr": err, "code": p.returncode}

            return {"verdict": "error", "reason": "empty_output", "code": p.returncode}

        except Exception as e:
            return {"verdict": "error", "reason": str(e)}


def _run_download(scan_client: ScanClient):
    try:
        download_watcher.main(scan_client=scan_client)
    except TypeError:
        download_watcher.main()
    except Exception as e:
        print(f"[rtp_main] download module crashed: {e}", flush=True)


def _run_process(scan_client: ScanClient):
    try:
        interval = float(os.environ.get("CS_PROC_SNAPSHOT_INTERVAL", "5") or "5")
        ProcessRtp(snapshot_interval_s=interval, scan_client=scan_client).start()
    except TypeError:
        interval = float(os.environ.get("CS_PROC_SNAPSHOT_INTERVAL", "5") or "5")
        ProcessRtp(snapshot_interval_s=interval).start()
    except Exception as e:
        print(f"[rtp_main] process module crashed: {e}", flush=True)


def main():
    root_dir, self_dir, engine, defs, key = _resolve_paths()
    _setup_file_logging(self_dir)
    scan_client = ScanClient(engine, defs, key)
    
    lock = _acquire_single_instance()
    if lock is None:
        print(f"[{_now()}] RTP already running, exiting", flush=True)
        return 0

    print(f"[{_now()}] self_dir={self_dir}", flush=True)
    print(f"[{_now()}] root_dir={root_dir}", flush=True)
    print(f"[{_now()}] engine={engine}", flush=True)
    print(f"[{_now()}] defs={defs}", flush=True)
    print(f"[{_now()}] key={key}", flush=True)

    t1 = threading.Thread(target=_run_download, args=(scan_client,), daemon=True)
    t2 = threading.Thread(target=_run_process, args=(scan_client,), daemon=True)

    t1.start()
    t2.start()

    try:
        while True:
            time.sleep(0.5)
    except KeyboardInterrupt:
        pass
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
