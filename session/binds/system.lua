-- Screenshots, power, and window/system odds and ends.

local M = {}

function M.apply(cfg)
    local mod, ipc = cfg.mod, cfg.ipc

    hl.bind(mod .. " + SHIFT + S",        hl.dsp.exec_cmd(ipc .. "screenshot-region"))
    hl.bind(mod .. " + CTRL + SHIFT + S", hl.dsp.exec_cmd(ipc .. "screenshot-fullscreen"))
    hl.bind("PRINT",                      hl.dsp.exec_cmd(ipc .. "screenshot-fullscreen"))

    hl.bind(mod .. " + SHIFT + P", hl.dsp.dpms({ action = "off" }))
    hl.bind(mod .. " + SHIFT + Q", hl.dsp.exit())

    hl.bind("ALT + F4",           hl.dsp.window.close())
    hl.bind(mod .. " + Q",        hl.dsp.window.close())
    hl.bind("ALT + Tab",          hl.dsp.exec_cmd(ipc .. "window-switcher"))
    hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
    hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
    hl.bind(mod .. " + CTRL + R",  hl.dsp.exec_cmd("hyprctl reload"))

    -- Escape hatch when a fullscreen app has grabbed the keyboard.
    hl.bind(mod .. " + ESCAPE", hl.dsp.exec_cmd("hyprctl dispatch submap reset"))
end

return M
