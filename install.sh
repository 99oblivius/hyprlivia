#!/usr/bin/env bash
# Deploy this config into ~/.config.
#
# hyprland.lua and .luarc.json are copied rather than linked: Noctalia appends
# its palette include to hyprland.lua, which would write through a symlink into
# the checkout. session/ and noctalia/ are linked, so edits here take effect on
# `hyprctl reload`.
set -euo pipefail

REPO="$(cd "$(dirname "$0")" && pwd)"
CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}"
HYPR="$CONFIG/hypr"
STATE="${XDG_STATE_HOME:-$HOME/.local/state}/noctalia"

say() { printf ':: %s\n' "$*"; }

say "copying hyprland.lua and .luarc.json into $HYPR"
mkdir -p "$HYPR"
cp -f "$REPO/hyprland.lua" "$HYPR/hyprland.lua"
cp -f "$REPO/.luarc.json" "$HYPR/.luarc.json"

say "linking session/ and noctalia/"
if [ -e "$HYPR/session" ] && [ ! -L "$HYPR/session" ]; then
    echo "   $HYPR/session exists and is not a symlink; move it aside first" >&2
    exit 1
fi
ln -sfn "$REPO/session" "$HYPR/session"

mkdir -p "$CONFIG/noctalia"
if [ -e "$CONFIG/noctalia/config.toml" ] && [ ! -L "$CONFIG/noctalia/config.toml" ]; then
    echo "   $CONFIG/noctalia/config.toml exists and is not a symlink; move it aside first" >&2
    exit 1
fi
ln -sfn "$REPO/noctalia/config.toml" "$CONFIG/noctalia/config.toml"

say "settings.toml is GUI-managed; copying only if absent"
mkdir -p "$STATE"
if [ -e "$STATE/settings.toml" ]; then
    echo "   $STATE/settings.toml present — left untouched"
else
    cp "$REPO/noctalia/settings.toml" "$STATE/settings.toml"
    echo "   installed $STATE/settings.toml"
fi

say "verifying"
hyprctl configerrors || true
