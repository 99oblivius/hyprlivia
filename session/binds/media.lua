-- Media and brightness keys. `locked` keeps them live on the lock screen.

local M = {}

local KEYS = {
    { "XF86AudioRaiseVolume", "volume-up" },
    { "XF86AudioLowerVolume", "volume-down" },
    { "XF86AudioMute",        "volume-mute" },
    { "XF86AudioMicMute",     "mic-mute" },
    { "XF86AudioNext",        "media next" },
    { "XF86AudioPrev",        "media previous" },
    { "XF86AudioPlay",        "media toggle" },
    { "XF86AudioPause",       "media stop" },
    { "XF86MonBrightnessUp",   "brightness-up" },
    { "XF86MonBrightnessDown", "brightness-down" },
}

function M.apply(cfg)
    for _, k in ipairs(KEYS) do
        hl.bind(k[1], hl.dsp.exec_cmd(cfg.ipc .. k[2]), { locked = true })
    end
end

return M
