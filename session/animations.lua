-- Real springs, replacing the bezier approximations the ML4W config used.
--
-- `speed` is required by hl.animation but ignored on the spring path, so the
-- timing comes only from stiffness and dampening. Critical damping is
-- dampening = 2 * sqrt(stiffness * mass); below it the curve overshoots.

local M = {}

local SPRING = { name = "snap", mass = 2.0, stiffness = 1000, dampening = 70.0 }

local LEAVES = {
    { leaf = "windows",          style = "popin 60%" },
    { leaf = "windowsIn",        style = "popin 80%" },
    { leaf = "windowsOut",       style = "popin 80%" },
    { leaf = "workspaces",       style = "slide" },
    { leaf = "specialWorkspace", style = "slidevert" },
}

function M.apply(_)
    hl.config({ animations = { enabled = true } })

    hl.curve(SPRING.name, {
        type      = "spring",
        mass      = SPRING.mass,
        stiffness = SPRING.stiffness,
        dampening = SPRING.dampening,
    })

    -- `global` reaches every leaf that does not override it. borderangle,
    -- shadowangle and glowangle are left out: they loop continuously and
    -- initialise disabled.
    hl.animation({ leaf = "global", enabled = true, speed = 1.2, spring = SPRING.name })

    for _, a in ipairs(LEAVES) do
        hl.animation({
            leaf    = a.leaf,
            enabled = true,
            speed   = 1.2,
            spring  = SPRING.name,
            style   = a.style,
        })
    end
end

return M
