#!/usr/bin/env bash
# Power menu using fuzzel. Bound to SUPER+X in hyprland.lua.

menu() { fuzzel --dmenu --prompt "$1" --lines "$2" --width 22; }
confirm() { [ "$(printf 'No\nYes\n' | menu "$1? " 2)" = "Yes" ]; }

choice=$(printf '%s\n' "Lock" "Log out" "Suspend" "Reboot" "Shut down" | menu "Power  " 5)

case "$choice" in
    "Lock")      pidof hyprlock >/dev/null || hyprlock ;;
    "Log out")   confirm "Log out"   && hyprctl dispatch 'hl.dsp.exit()' ;;
    "Suspend")   systemctl suspend ;;
    "Reboot")    confirm "Reboot"    && systemctl reboot ;;
    "Shut down") confirm "Shut down" && systemctl poweroff ;;
esac
