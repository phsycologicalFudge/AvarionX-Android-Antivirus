import os
import sys
import time
import threading
from pathlib import Path
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler


def _downloads_dir() -> Path:
    p = Path.home() / "Downloads"
    if p.exists():
        return p
    up = os.environ.get("USERPROFILE")
    if up:
        p2 = Path(up) / "Downloads"
        if p2.exists():
            return p2
    return Path.home()


def _now():
    return time.strftime("%Y-%m-%d %H:%M:%S")


class _Pending:
    def __init__(self, settle_seconds: float = 1.5):
        self.settle_seconds = settle_seconds
        self.lock = threading.Lock()
        self.pending = {}

    def touch(self, path: str):
        with self.lock:
            self.pending[path] = time.time()

    def pop_ready(self):
        ready = []
        cutoff = time.time() - self.settle_seconds
        with self.lock:
            for p, t in list(self.pending.items()):
                if t <= cutoff:
                    ready.append(p)
                    del self.pending[p]
        return ready


class DownloadWatcher(FileSystemEventHandler):
    def __init__(self, pending: _Pending):
        self.pending = pending

    def on_created(self, event):
        if event.is_directory:
            return
        p = event.src_path
        print(f"[{_now()}] created  {p}", flush=True)
        self.pending.touch(p)

    def on_modified(self, event):
        if event.is_directory:
            return
        p = event.src_path
        print(f"[{_now()}] modified {p}", flush=True)
        self.pending.touch(p)

    def on_moved(self, event):
        if event.is_directory:
            return
        dst = event.dest_path
        print(f"[{_now()}] moved    {event.src_path} -> {dst}", flush=True)
        self.pending.touch(dst)

    def on_deleted(self, event):
        if event.is_directory:
            return
        print(f"[{_now()}] deleted  {event.src_path}", flush=True)


def main(scan_client=None):
    if not scan_client or not scan_client.ready():
        print(f"[{_now()}] scan client not ready", flush=True)
        return 1

    watch_dir = _downloads_dir()
    if not watch_dir.exists():
        print(f"Downloads folder not found: {watch_dir}", file=sys.stderr)
        return 2

    print(f"[{_now()}] watching: {watch_dir}", flush=True)

    pending = _Pending(settle_seconds=1.5)
    handler = DownloadWatcher(pending)
    observer = Observer()
    observer.schedule(handler, str(watch_dir), recursive=True)
    observer.start()

    try:
        while True:
            for p in pending.pop_ready():
                try:
                    if not os.path.isfile(p):
                        continue

                    st = os.stat(p)
                    print(f"[{_now()}] ready    {p} ({st.st_size} bytes)", flush=True)

                    verdict = scan_client.scan_path(p)
                    bad = str(verdict.get("verdict", "")).lower() in (
                        "malicious",
                        "malware",
                        "infected",
                        "bad",
                        "deny",
                        "block",
                    )

                    if bad:
                        print(f"[{_now()}] MALICIOUS download {p} verdict={verdict}", flush=True)
                    else:
                        print(f"[{_now()}] ok download {p} verdict={verdict}", flush=True)

                except FileNotFoundError:
                    pass
                except Exception as e:
                    print(f"[{_now()}] scan error {p} {e}", flush=True)

            time.sleep(0.2)
    except KeyboardInterrupt:
        pass
    finally:
        observer.stop()
        observer.join()

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
