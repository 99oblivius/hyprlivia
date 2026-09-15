-- Entry point for the session. `session/` holds the layered tree; this file
-- exists so the compositor has a single stable load target.
--
-- Noctalia appends its palette include to this file, so it must be a real file
-- in ~/.config/hypr rather than a symlink into the repo.
require("session").boot()

-- Noctalia-generated palette. Absent on a fresh clone until the shell has run
-- once, so the require is guarded: an unguarded one aborts the whole config
-- parse and the session comes up with no config at all.
local has_palette, palette = pcall(require, "noctalia")
if has_palette then
    palette.apply_theme()
else
    print("[hyprlivia] noctalia.lua not generated yet; theme left at Hyprland defaults")
end
