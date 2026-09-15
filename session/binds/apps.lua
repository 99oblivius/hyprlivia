-- Application launchers.

local M = {}

function M.apply(cfg)
    local mod = cfg.mod

    hl.bind(mod .. " + RETURN",      hl.dsp.exec_cmd("ghostty"))
    hl.bind(mod .. " + B",           hl.dsp.exec_cmd("zen-browser"))
    hl.bind(mod .. " + E",           hl.dsp.exec_cmd("nautilus --new-window"))
    hl.bind(mod .. " + SHIFT + E",   hl.dsp.exec_cmd("zeditor"))
    hl.bind("CTRL + SHIFT + escape", hl.dsp.exec_cmd("ghostty -e btop"))
end

return M
