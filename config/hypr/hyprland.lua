-- ~/.config/hypr/hyprland.lua -- Hyprbolic
-- Hyprland 0.56 Lua config: single monitor, flat 1-9 workspaces.
-- Syntax follows the stock example config that ships with Hyprland's Lua support.

------------------
---- MONITORS ----
------------------
-- Single-monitor layout. Run `hyprctl monitors` after first boot and adjust the
-- mode (resolution@refresh) to match your actual display if it's not 2560x1440.
hl.monitor({ output = "", mode = "2560x1440@144", position = "auto", scale = "1" })

---------------------
---- MY PROGRAMS ----
---------------------
local terminal    = "kitty"
local fileManager  = "dolphin"
local menu         = "fuzzel"
local browser      = "firefox"

-------------------
---- AUTOSTART ----
-------------------
hl.on("hyprland.start", function()
    hl.exec_cmd("hyprlock")
    hl.exec_cmd("waybar")
    hl.exec_cmd("mako")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("swaybg -i $HOME/.config/hypr/wallpaper.png -m fill")
    -- Polkit agent; path differs by distro/desktop stack. Check what's actually
    -- installed on the target base (e.g. `dpkg -L policykit-1-gnome` on Debian/Kali).
    hl.exec_cmd("/usr/libexec/kf6/polkit-kde-authentication-agent-1")
    -- Clipboard history
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
end)

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
-- TODO: QT_QPA_PLATFORMTHEME=kde and XDG_MENU_PREFIX=plasma- assumed a KDE/Plasma
-- install on the Fedora box this was written on. Kali won't have those Plasma
-- packages by default -- decide whether to install qt6ct instead, or drop these.

-----------------------
---- LOOK AND FEEL ----
-----------------------
hl.config({
    general = {
        gaps_in = 6,
        gaps_out = 12,
        border_size = 2,
        resize_on_border = true,
        allow_tearing = false,
        layout = "dwindle",
        ["col.active_border"] = { colors = { "rgba(88d1ecb3)", "rgba(c3c3ebb3)" }, angle = 45 },
        ["col.inactive_border"] = "rgba(40484cff)",
    },

    decoration = {
        rounding = 14,
        rounding_power = 2,
        active_opacity = 1.0,
        inactive_opacity = 1.0,
        shadow = { enabled = true, range = 20, render_power = 3, color = "rgba(0000008c)" },
        blur = { enabled = true, size = 6, passes = 3, noise = 0.015, vibrancy = 0.2 },
    },

    animations = {
        enabled = true,
    },
})

-- Default animation curves and animations from the stock config
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1}, {0.32, 1} } })
hl.curve("linear",         { type = "bezier", points = { {0, 0}, {1, 1} } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5}, {0.75, 1} } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0}, {0.1, 1} } })
hl.curve("easy",           { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })
hl.curve("smooth",         { type = "bezier", points = { {0.23, 1}, {0.32, 1} } })

hl.animation({ leaf = "global",     enabled = true, speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",     enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",    enabled = true, speed = 4, bezier = "smooth" })
hl.animation({ leaf = "windowsIn",  enabled = true, speed = 4.1,  spring = "easy", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fade",       enabled = true, speed = 3, bezier = "smooth" })
hl.animation({ leaf = "layers",     enabled = true, speed = 4, bezier = "smooth" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 4, bezier = "smooth" })

hl.config({
    dwindle = {
        preserve_split = true,
    },
    misc = {
        disable_hyprland_logo = true,
        vrr = 1, -- adaptive sync when a fullscreen app on a capable monitor wants it
    },
})

---------------
---- INPUT ----
---------------
hl.config({
    input = {
        kb_layout = "se",
        kb_variant = "",
        kb_model = "",
        kb_options = "", -- e.g. "caps:escape" to make Caps Lock act as Escape
        kb_rules = "",
        follow_mouse = 1,
        sensitivity = 0,
    },
})

---------------------
---- KEYBINDINGS ----
---------------------
local mainMod = "SUPER" -- the Windows key

-- Apps
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + D",      hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + E",      hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + B",      hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + V",      hl.dsp.exec_cmd("cliphist list | fuzzel --dmenu | cliphist decode | wl-copy"))
hl.bind(mainMod .. " + L",      hl.dsp.exec_cmd("hyprlock"))

-- Window management
hl.bind(mainMod .. " + Q",         hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exit())
hl.bind(mainMod .. " + Space",     hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P",         hl.dsp.window.pseudo())
hl.bind(mainMod .. " + T",         hl.dsp.layout("togglesplit")) -- dwindle only
hl.bind(mainMod .. " + F",         hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))

-- Move focus
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- Workspaces: flat 1-9. Super+[1-9] switches, Super+Shift+[1-9] moves the window there,
-- Super+comma / Super+period step to the previous/next workspace that actually has windows.
for i = 1, 9 do
    hl.bind(mainMod .. " + " .. i,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end
hl.bind(mainMod .. " + comma",  hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + period", hl.dsp.focus({ workspace = "e+1" }))

-- Drag / resize with the mouse
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Screenshots: Print = select an area to clipboard, Shift+Print = full screen to file
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd('grim -g "$(slurp)" - | wl-copy'))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd('grim ~/Pictures/screenshot-$(date +%F-%H%M%S).png'))

-- Volume / brightness / media keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioNext",        hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPlay",        hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",        hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

-- Do not disturb
hl.bind(mainMod .. " + F10", hl.dsp.exec_cmd("makoctl mode -t do-not-disturb"))

-- Power menu through fuzzel
hl.bind(mainMod .. " + X", hl.dsp.exec_cmd("$HOME/.config/hypr/scripts/powermenu.sh"))

-- Emergency: SUPER+SHIFT+Q kills the focused window's process, even if it grabbed the keyboard
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exec_cmd("sh -c 'kill -9 $(hyprctl activewindow -j | jq -r .pid)'"), { dont_inhibit = true })

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------
-- Ignore maximize requests from apps (from the stock config)
hl.window_rule({
    name = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

-- Fix some XWayland dragging issues (from the stock config)
hl.window_rule({
    name = "fix-xwayland-drags",
    match = {
        class = "^$",
        title = "^$",
        xwayland = true,
        float = true,
        fullscreen = false,
        pin = false,
    },
    no_focus = true,
})

hl.layer_rule({ name = "waybar-blur", match = { namespace = "waybar" },        blur = true, ignore_alpha = 0.5 })
hl.layer_rule({ name = "mako-blur",   match = { namespace = "notifications" }, blur = true, ignore_alpha = 0.3 })
hl.layer_rule({ name = "fuzzel-blur", match = { namespace = "launcher" },      blur = true, ignore_alpha = 0.3 })

-- Firefox opens on workspace 1 by default (handy fixed spot for proxying through Burp,
-- viewing sqlmap/ffuf/updog web output, etc.), except its picture-in-picture window.
hl.window_rule({
    name = "firefox-home",
    match = { class = "^(firefox|org.mozilla.firefox)$", title = "negative:^Picture-in-Picture$" },
    workspace = "1 silent",
})

hl.window_rule({
    name = "firefox-pip",
    match = { title = "^Picture-in-Picture$" },
    float = true,
    pin = true,
})

-- Don't let hypridle lock or blank the screen during any fullscreen window
hl.window_rule({
    name = "idle-inhibit-fullscreen",
    match = { class = ".*" },
    idle_inhibit = "fullscreen",
})

-- Small utility windows float in the middle of the screen
hl.window_rule({
    name = "float-utilities",
    match = { class = "^(pavucontrol|nm-connection-editor|org.kde.polkit-kde-authentication-agent-1|blueman-manager)$" },
    float = true,
    center = true,
})

-- Dolphin: kitty-style translucent + blurred background.
hl.window_rule({
    name = "dolphin-blur",
    match = { class = "^org.kde.dolphin$" },
    opacity = "0.90 override 0.80 override",
})

-- virt-manager's main list window is small and shouldn't tile
hl.window_rule({
    name = "virt-manager-list",
    match = { class = "^virt-manager$", title = "^Virtual Machine Manager$" },
    float = true,
    center = true,
})

-- TODO: window rules for GUI pentest tools (Burp Suite, Wireshark, etc).
-- Don't guess window classes here -- they vary by exact build/launcher. Once a tool
-- is installed, run it, then check its real class/title with:
--   hyprctl clients
-- (or `xwininfo` for an XWayland app), then add a hl.window_rule({...}) below using
-- the confirmed class. The Battle.net rule in the original desktop config was built
-- this way (verified via xwininfo) -- same method applies here.
