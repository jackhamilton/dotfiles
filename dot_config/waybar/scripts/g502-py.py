#!/usr/bin/env python3
"""Live DPI for Logitech G502 X — raw HID++ 2.0 over /dev/hidraw.

Reads the sensor directly (feature 0x2201 getSensorDpi) so the value always
matches the hardware, including onboard DPI+ / DPI- presses (ratbagctl's
cache goes stale on this mouse)."""
import errno, glob, json, os, select, sys, time

CACHE = "/tmp/g502_dpi.json"
DEBUG = "--debug" in sys.argv
_t0 = time.monotonic()
def log(*a):
    if DEBUG: print(f"[{time.monotonic()-_t0:6.3f}]", *a, file=sys.stderr)

IRoot, FEAT_DPI, SHORT, SW = 0x0000, 0x2201, 0x10, 0x08
TIMEOUT_S = 0.25
DEV_IDXS = (0xFF, 0x00, 1, 2, 3, 4, 5, 6)   # 0xff = wired; 0/1..6 = receiver slots
EPIPE = "EPIPE"

def hidpp_nodes():
    out = []
    for node in sorted(glob.glob("/dev/hidraw*")):
        try:
            devdir = os.path.realpath(f"/sys/class/hidraw/{os.path.basename(node)}/device")
            desc = open(f"{devdir}/report_descriptor", "rb").read()
        except Exception:
            continue
        if b"\x85\x10" in desc or any(p in desc for p in
            (b"\x06\x00\xff", b"\x06\x43\xff", b"\x06\xc0\xff")):
            out.append(node)
    return out

def read_report(fd):
    r, _, _ = select.select([fd], [], [], TIMEOUT_S)
    if not r: return None
    try:
        data = os.read(fd, 64)
    except (BlockingIOError, OSError):
        return None
    if not data: return None
    off = 1 if data[0] in (0x10, 0x11) else 0
    return data[off:] if len(data) >= off + 4 else None

def request(fd, dev_idx, feat_idx, fn, params, attempts=3):
    payload = bytes([SHORT, dev_idx, feat_idx, (fn << 4) | SW] + list(params))
    try:
        os.write(fd, payload)
    except OSError as e:
        if e.errno == errno.EPIPE:
            return EPIPE                      # interface has no OUT endpoint
        log("write failed:", e); return None
    for _ in range(attempts):
        msg = read_report(fd)
        if msg is None:
            log(f"  (timeout dev={dev_idx:#x} feat={feat_idx:#04x} fn={fn})")
            return None
        rfeat, rfsw = msg[1], msg[2]
        if rfeat == 0xFF:
            log(f"  HID++ error: {msg[3:].hex()}"); return None
        if rfeat == feat_idx and (rfsw & 0x0F) == SW:
            return msg[3:]
    return None

def get_feature(fd, dev_idx, fid):
    p = request(fd, dev_idx, IRoot, 0x00, [fid >> 8, fid & 0xFF, 0x00], attempts=2)
    if p == EPIPE: return EPIPE
    if not p or len(p) < 2: return None
    if p[0] == 0x01: return p[1]              # spec: [success, feature_index]
    if p[1] == 0 and 1 <= p[0] <= 0xFF: return p[0]
    log(f"  getFeature params unexpected: {p.hex()}"); return None

def get_dpi(fd, dev_idx, feat_idx):
    p = request(fd, dev_idx, feat_idx, 0x02, [0x00, 0x00, 0x00])
    if p == EPIPE: return EPIPE
    if not p or len(p) < 3: return None
    return (p[1] << 8) | p[2]

def drain(fd, n=8):
    for _ in range(n):
        r, _, _ = select.select([fd], [], [], 0.05)
        if not r: return
        try: os.read(fd, 64)
        except (BlockingIOError, OSError): return

def main():
    nodes = hidpp_nodes()
    log("candidates:", nodes or "none")
    if not nodes:
        print("offline"); return 0

    try: state = json.load(open(CACHE))
    except Exception: state = {}
    cached_node, cached_dev, cached_feat = state.get("node"), state.get("dev_idx"), state.get("feat_idx")

    # FIX: cached node FIRST (if still present), then the rest — no more
    # re-probing dead interfaces on every poll.
    order = nodes
    if cached_node in nodes:
        order = [cached_node] + [n for n in nodes if n != cached_node]
    elif cached_node and os.path.exists(cached_node):
        order = [cached_node] + nodes

    for node in order:
        try:
            fd = os.open(node, os.O_RDWR | os.O_NONBLOCK)
        except PermissionError:
            log(f"{node}: permission denied"); continue
        except OSError as e:
            log(f"{node}: {e}"); continue
        try:
            drain(fd)
            dpi = get_dpi(fd, cached_dev, cached_feat) if cached_feat and cached_node == node else None
            if dpi == EPIPE:                     # stale cache → treat as unprobed
                dpi = None
            if dpi is None:
                dead = False
                for didx in DEV_IDXS:
                    f = get_feature(fd, didx, FEAT_DPI)
                    if f == EPIPE:               # read-only interface: skip node entirely
                        log(f"{node}: not writable (EPIPE), skipping")
                        dead = True
                        break
                    if f is None: continue
                    dpi = get_dpi(fd, didx, f)
                    if dpi == EPIPE:
                        dead = True; break
                    if dpi is not None:
                        cached_dev, cached_feat = didx, f
                        log(f"{node}: matched dev={didx:#x} feat={f:#04x}")
                        break
                if dead: continue
            if dpi is not None:
                try: json.dump({"node": node, "dev_idx": cached_dev, "feat_idx": cached_feat},
                               open(CACHE, "w"))
                except Exception: pass
                print(f"{dpi} dpi")
                return 0
        finally:
            os.close(fd)
    print("offline")
    return 0

if __name__ == "__main__":
    sys.exit(main())
