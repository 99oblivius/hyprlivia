-- Monitors and workspaces.
--
-- Outputs match by EDID description: the NVIDIA driver renumbers DP-*/HDMI-A-*
-- between boots.

local M = {}

local DELL   = "desc:Dell Inc. Dell AW2721D"
local AOC271 = "desc:AOC AG271QG"
local AOC241 = "desc:AOC AG241QG4"

function M.apply(_)
    hl.monitor({ output = DELL,   mode = "2560x1440@239.97", position = "0x0",      scale = 1, vrr = 1 })
    hl.monitor({ output = AOC271, mode = "2560x1440@120",    position = "-2560x125", scale = 1 })
    hl.monitor({ output = AOC241, mode = "2560x1440@120",    position = "0x-1440",   scale = 1 })
    hl.monitor({ output = "",     mode = "preferred",        position = "auto",      scale = 1 })

    -- Persistence belongs only to the three pinned displays: a wider range is
    -- materialised up front on whichever monitor owns the default workspace.
    for i = 1, 3 do
        hl.workspace_rule({ workspace = tostring(i), persistent = true })
    end

    hl.workspace_rule({ workspace = "1", monitor = DELL,   default = true })
    hl.workspace_rule({ workspace = "2", monitor = AOC271 })
    hl.workspace_rule({ workspace = "3", monitor = AOC241 })
end

return M
