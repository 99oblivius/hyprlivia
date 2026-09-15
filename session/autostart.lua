-- Session startup.

local M = {}

function M.apply(_)
    hl.on("hyprland.start", function()
        hl.exec_cmd("noctalia --daemon")

        -- Noctalia provides no input method.
        hl.exec_cmd("fcitx5 -d --replace")

        hl.exec_cmd("wl-paste --type text --watch cliphist store")
        hl.exec_cmd("wl-paste --type image --watch cliphist store")
    end)
end

return M
