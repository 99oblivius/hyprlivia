-- Noctalia shell surfaces.

local M = {}

function M.apply(cfg)
    local mod, ipc = cfg.mod, cfg.ipc

    hl.bind(mod .. " + SPACE",          hl.dsp.exec_cmd(ipc .. "panel-toggle launcher"))
    hl.bind(mod .. " + I",              hl.dsp.exec_cmd(ipc .. "settings-toggle"))
    hl.bind(mod .. " + U",              hl.dsp.exec_cmd(ipc .. "panel-toggle control-center"))
    hl.bind(mod .. " + CTRL + ALT + W", hl.dsp.exec_cmd(ipc .. "panel-toggle wallpaper"))
    hl.bind(mod .. " + V",              hl.dsp.exec_cmd(ipc .. "panel-toggle clipboard"))
    hl.bind(mod .. " + L",              hl.dsp.exec_cmd(ipc .. "session lock"))
    hl.bind("CTRL + ALT + DELETE",      hl.dsp.exec_cmd(ipc .. "panel-toggle session"))
end

return M
