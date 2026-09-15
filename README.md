# hyprlivia

Personal Hyprland session: a Lua-native compositor config with the
[Noctalia](https://github.com/noctalia-dev/noctalia) shell as the desktop.

No dotfile generator, no templating layer, no wrapper. Hyprland reads Lua
directly — `hl.*` is the compositor's own API — so this is a plain configuration,
split into modules that can be read on their own.

## Layout

```
hyprland.lua          entry point; boots session/, then loads Noctalia's palette
session/
  init.lua            module registry and boot order
  options.lua         general, decoration, input, layout
  animations.lua      spring curves and per-leaf animation bindings
  monitors.lua        per-monitor geometry, pinned by EDID description
  autostart.lua       session daemons
  noctalia.lua        the noctalia-* layer rules
  binds/
    apps.lua          launchers
    shell.lua         shell control (bar, panel, lock, screenshots)
    media.lua         volume, media keys, brightness
    windows.lua       focus, move, resize, float
    workspaces.lua    workspace navigation and window routing
    system.lua        session, power, hardware
noctalia/
  config.toml         hand-authored shell config
  settings.toml       shell preferences, as written by the Settings GUI
```

## Install

`hyprland.lua` must be a real file, not a symlink: Noctalia appends its palette
include to it, which would otherwise write through into this repository.

```bash
cp -r session noctalia ~/.config/
cp hyprland.lua .luarc.json ~/.config/hypr/
```

`noctalia.lua` is **not** part of this repository. The shell generates it on
first run; until then the config loads with Hyprland's default theme colours and
says so on stdout.

`noctalia/settings.toml` is GUI-managed — values written from the Settings UI
land there and shadow anything in `config.toml`, so edit a GUI-owned setting in
the GUI rather than duplicating it. It carries machine-specific entries
(monitor connectors `DP-4` / `DP-6` / `HDMI-A-2`, wallpaper paths under
`$HOME/Pictures`) and will need those changed elsewhere.

## Requirements

- Hyprland with the Lua config loader
- Noctalia (`noctalia --daemon`) for the bar, launcher, notifications,
  lock screen, idle handling, wallpapers, screenshots and polkit agent
- `fcitx5`, `cliphist`, `awww-daemon` for input method, clipboard history and
  wallpaper

## Editor support

`.luarc.json` points lua-language-server at Hyprland's bundled stubs
(`/usr/share/hypr/stubs`) and pins the runtime to **Lua 5.5** — the version
Hyprland embeds, not 5.4.

## License

Public domain, per [Unlicense](LICENSE).
