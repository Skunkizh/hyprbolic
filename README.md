# Hyprbolic

A Hyprland desktop setup for Kali Linux: the theming, keybinds, and window management from
my own daily Hyprland desktop, with pentest tooling installed instead of my personal apps.

Built with AI pair-programming assistance (Claude).

## What you get

- **Hyprland** (0.56, Lua config) -- single-monitor layout, flat 1-9 workspaces, blur +
  rounded corners + animations in a dark cyan/lavender theme.
- **Waybar** -- based on [haikal-hakim/athena](https://github.com/haikal-hakim/athena) (MIT),
  with a workspace indicator and quick-launch icons for Burp Suite and Wireshark.
- **kitty** terminal, **fuzzel** launcher, **hyprlock** screen lock -- same palette throughout.
- **Pentest tools**, installed from Kali's own repos (no manual builds):
  Burp Suite, Wireshark, nmap, tcpdump, proxychains4, socat, Hydra, aircrack-ng, sqlmap,
  NetExec, Hashcat, John the Ripper, RustScan, Naabu, ffuf, Gobuster, updog (via pipx),
  plus Kali's `rockyou.txt` wordlist.

## Install

```sh
git clone https://github.com/Skunkizh/hyprbolic.git
cd hyprbolic
./install.sh
```

Run it as your normal user, **not** with `sudo` -- it calls `sudo` itself for the apt steps.
It will ask for confirmation before installing anything, and backs up any existing
`~/.config/hypr`, `~/.config/waybar`, `~/.config/kitty`, `~/.config/fuzzel`, and
`~/.config/hyprlock` (as `<name>.bak-<timestamp>`) before replacing them.

After it finishes, log out and pick the Hyprland session at your login manager (or run
`Hyprland` from a TTY), then install a [Nerd Font](https://www.nerdfonts.com/font-downloads)
(JetBrainsMono Nerd Font) so the waybar/kitty/fuzzel icons render correctly.

## Keybinds

| Key | Action |
|---|---|
| `SUPER + Return` | Terminal (kitty) |
| `SUPER + D` | App launcher (fuzzel) |
| `SUPER + E` | File manager (Dolphin) |
| `SUPER + B` | Browser (Firefox) |
| `SUPER + V` | Clipboard history |
| `SUPER + L` | Lock screen |
| `SUPER + Q` | Close window |
| `SUPER + SHIFT + E` | Exit Hyprland |
| `SUPER + Space` | Toggle floating |
| `SUPER + F` | Toggle fullscreen |
| `SUPER + [1-9]` | Switch to workspace |
| `SUPER + SHIFT + [1-9]` | Move window to workspace |
| `SUPER + ,` / `SUPER + .` | Previous / next workspace |
| `SUPER + S` | Screenshot area to clipboard |
| `SHIFT + Print` | Screenshot full screen to file |
| `SUPER + X` | Power menu |
| `SUPER + F10` | Toggle do-not-disturb |
| `SUPER + SHIFT + Q` | Force-kill focused window |

## After install: things worth tuning yourself

- **Wallpaper**: `wallpapers/hyprbolic-wallpaper.png` is just a generated placeholder (a
  solid-color gradient, no copyright concerns). Drop your own image into `wallpapers/`,
  then update the path in `config/hypr/hyprland.lua` (the `swaybg` line) and
  `config/hyprlock/hyprlock.conf` (the `$wall` variable) to point at it.
- **Window rules for GUI tools**: `config/hypr/hyprland.lua` has a TODO instead of guessed
  window-class rules for Burp Suite/Wireshark -- window classes vary by exact build. Once
  installed, run the tool, check its real class with `hyprctl clients`, then add a
  `hl.window_rule({...})` for it.
- **Monitor resolution**: defaults to 2560x1440. Run `hyprctl monitors` and adjust the
  `hl.monitor({...})` line in `hyprland.lua` if yours is different.
- **CPU temperature sensor**: `config/waybar/modules/system.jsonc` defaults to Intel's
  `coretemp` hwmon path. On AMD or other hardware, find the right path with
  `ls /sys/class/hwmon/*/name` and update it.

## Credits / license

MIT licensed -- see [LICENSE](LICENSE). Waybar theme based on
[haikal-hakim/athena](https://github.com/haikal-hakim/athena) (MIT); see
[`config/waybar/NOTICE`](config/waybar/NOTICE). hyprlock layout adapted from
["Layout 12"](https://github.com/mahaveergurjar/Hyprlock-Dots) by mahaveergurjar.
