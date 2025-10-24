#!/usr/bin/env python3
"""
Simple file-backed pomodoro timer for Waybar.
Usage:
  pomodoro.py status        -> prints json: {"text":"25:00","icon":""}
  pomodoro.py toggle        -> start/stop
  pomodoro.py reset         -> reset timer
This is intentionally simple. For more robust behavior integrate with a daemon.
"""

import sys, json, time, os

STATE_FILE = os.path.expanduser("~/.config/waybar/pomodoro_state.json")
DEFAULT = {
    "running": False,
    "mode": "work",
    "remaining": 25 * 60,
    "work_duration": 25 * 60,
    "break_duration": 5 * 60,
    "long_break": 15 * 60,
    "sessions": 0,
}


def load():
    if os.path.exists(STATE_FILE):
        try:
            with open(STATE_FILE, "r") as f:
                return json.load(f)
        except:
            return DEFAULT.copy()
    return DEFAULT.copy()


def save(s):
    os.makedirs(os.path.dirname(STATE_FILE), exist_ok=True)
    with open(STATE_FILE, "w") as f:
        json.dump(s, f)


def human(sec):
    m = sec // 60
    s = sec % 60
    return f"{m:02d}:{s:02d}"


def status():
    s = load()
    icon = "\uf252" if s["mode"] == "work" else "\uf253"
    if s["running"]:
        # decrease by wall time since last tick — simplified: count down each call
        s["remaining"] = max(0, s["remaining"] - 1)
        if s["remaining"] == 0:
            # flip
            if s["mode"] == "work":
                s["mode"] = "break"
                s["remaining"] = s["break_duration"]
            else:
                s["mode"] = "work"
                s["remaining"] = s["work_duration"]
        save(s)
    print(json.dumps({"text": human(s["remaining"]), "icon": icon}))


def toggle():
    s = load()
    s["running"] = not s["running"]
    save(s)


def reset():
    s = DEFAULT.copy()
    save(s)


if __name__ == "__main__":
    cmd = sys.argv[1] if len(sys.argv) > 1 else "status"
    if cmd == "status":
        status()
    elif cmd == "toggle":
        toggle()
    elif cmd == "reset":
        reset()
