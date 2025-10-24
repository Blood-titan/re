#!/usr/bin/env bash
# Very small script to open Code or list recent workspaces (best-effort).
case "$1" in
  open)
    code .
    ;;
  *)
    # Print simple static JSON for Waybar tooltip
    echo "{\"text\":\" recents\",\"tooltip\":\"Recent: Open VSCode\"}"
    ;;
esac
