#!/usr/bin/env bash
# Hyprbolic installer: Hyprland desktop (theming/layout) + pentest tooling, for Kali Linux.
#
# Run as your normal user (NOT with sudo) -- it calls sudo itself for the apt steps and
# needs $HOME to resolve to you, not root, for the dotfiles copy.
#
# What this does:
#   1. Installs the Hyprland desktop stack + pentest tools via apt.
#   2. Installs updog via pipx (not an apt package).
#   3. Backs up any existing configs this would overwrite, then copies this repo's
#      dotfiles into ~/.config.
#   4. Extracts rockyou.txt if it's still gzipped.
#   5. Prints manual next steps (sysreptor, Nerd Font, login).
#
# It does NOT silently install sysreptor -- that's a Docker web app with its own setup
# wizard, a different trust level than `apt install`, so instructions are printed instead.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_SRC="$SCRIPT_DIR/config"
WALLPAPER_SRC="$SCRIPT_DIR/wallpapers/hyprbolic-wallpaper.png"

if [[ "${EUID}" -eq 0 ]]; then
    echo "Don't run this as root / with sudo -- run it as your normal user." >&2
    exit 1
fi

if ! command -v apt-get >/dev/null 2>&1; then
    echo "No apt-get found. This installer targets Kali/Debian-based systems only." >&2
    exit 1
fi

echo "==> This will install packages system-wide via sudo apt-get, and will back up"
echo "    then overwrite configs in: ~/.config/hypr, ~/.config/waybar, ~/.config/kitty,"
echo "    ~/.config/fuzzel, ~/.config/hyprlock"
read -rp "Continue? [y/N] " reply
[[ "$reply" =~ ^[Yy]$ ]] || { echo "Aborted."; exit 1; }

# ---------------------------------------------------------------------------
# 1. Packages
# ---------------------------------------------------------------------------
# Verified present in Kali's own repo (kali-last-snapshot, main, amd64) as of Oct 2026.
# If a future Kali release drops/renames one of these, apt will just fail on that name --
# check `apt search <name>` and fix the array below rather than assuming the whole
# install is broken.

DESKTOP_PKGS=(
    hyprland hyprlock hypridle waybar mako-notifier fuzzel swaybg
    cliphist grim slurp wl-clipboard kitty dolphin firefox-esr
    pavucontrol blueman playerctl network-manager-applet lxqt-policykit jq
)

PENTEST_PKGS=(
    burpsuite hashcat john wireshark nmap tcpdump proxychains4 socat
    hydra aircrack-ng netexec sqlmap rustscan naabu ffuf gobuster
    wordlists pipx
)

echo "==> apt update"
sudo apt-get update

echo "==> Installing desktop + pentest packages"
failed_pkgs=()
for pkg in "${DESKTOP_PKGS[@]}" "${PENTEST_PKGS[@]}"; do
    echo "--- $pkg ---"
    if ! sudo apt-get install -y "$pkg"; then
        failed_pkgs+=("$pkg")
    fi
done

echo "==> Installing updog via pipx"
pipx install updog || failed_pkgs+=("updog (pipx)")

# ---------------------------------------------------------------------------
# 2. Dotfiles: back up anything that exists, then copy this repo's configs in
# ---------------------------------------------------------------------------
backup_stamp="$(date +%Y%m%d-%H%M%S)"

backup_and_copy() {
    local src="$1" dest="$2"
    if [[ -e "$dest" ]]; then
        echo "Backing up existing $dest -> ${dest}.bak-${backup_stamp}"
        mv "$dest" "${dest}.bak-${backup_stamp}"
    fi
    mkdir -p "$(dirname "$dest")"
    cp -r "$src" "$dest"
}

echo "==> Installing dotfiles into \$HOME/.config"
backup_and_copy "$CONFIG_SRC/hypr"     "$HOME/.config/hypr"
backup_and_copy "$CONFIG_SRC/waybar"   "$HOME/.config/waybar"
backup_and_copy "$CONFIG_SRC/kitty"    "$HOME/.config/kitty"
backup_and_copy "$CONFIG_SRC/fuzzel"   "$HOME/.config/fuzzel"
backup_and_copy "$CONFIG_SRC/hyprlock" "$HOME/.config/hyprlock"

cp "$WALLPAPER_SRC" "$HOME/.config/hypr/wallpaper.png"
chmod +x "$HOME/.config/hypr/scripts/powermenu.sh"

# ---------------------------------------------------------------------------
# 3. rockyou.txt: Kali ships it gzipped, extract it if needed
# ---------------------------------------------------------------------------
ROCKYOU_GZ="/usr/share/wordlists/rockyou.txt.gz"
ROCKYOU="/usr/share/wordlists/rockyou.txt"
if [[ -f "$ROCKYOU_GZ" && ! -f "$ROCKYOU" ]]; then
    echo "==> Extracting rockyou.txt"
    sudo gunzip -k "$ROCKYOU_GZ"
fi

# ---------------------------------------------------------------------------
# 4. Summary
# ---------------------------------------------------------------------------
echo
echo "==================== Hyprbolic install summary ===================="
if [[ ${#failed_pkgs[@]} -eq 0 ]]; then
    echo "All packages installed successfully."
else
    echo "These failed and need a manual look (check 'apt search <name>'):"
    printf '  - %s\n' "${failed_pkgs[@]}"
fi
cat <<'EOF'

Manual steps still needed:
  1. Install a Nerd Font (e.g. JetBrainsMono Nerd Font) for the icons used in
     waybar/kitty/fuzzel to render -- https://www.nerdfonts.com/font-downloads
  2. Burp Suite / Wireshark window rules: hyprland.lua has a TODO for these --
     once you've actually run each tool, check its real window class with
     `hyprctl clients` and fill in the matching hl.window_rule.
  3. sysreptor is a Docker web app, not a package -- this script did NOT install
     it. Follow the official guide: https://docs.sysreptor.com/setup/installation
  4. Log out and pick the Hyprland session at your login manager (or run
     `Hyprland` from a TTY).

EOF
