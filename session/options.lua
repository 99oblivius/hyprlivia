-- Compositor defaults: gaps, borders, input, decoration, layout.

local M = {}

function M.apply(_)
    hl.config({
        general = {
            gaps_in         = 10,
            gaps_out        = 20,
            border_size     = 1,
            resize_on_border = true,
            allow_tearing   = true,
        },

        input = {
            kb_layout          = "ch",
            kb_variant         = "fr",
            kb_model           = "",
            kb_options         = "",
            numlock_by_default = true,
            follow_mouse       = 1,
            mouse_refocus      = false,
            sensitivity        = 0.0,
            -- 1:1 pointer movement, no acceleration.
            accel_profile      = "flat",

            touchpad = {
                natural_scroll       = false,
                scroll_factor        = 1.0,
                disable_while_typing = false,
            },
        },

        decoration = {
            rounding           = 10,
            rounding_power     = 2,
            active_opacity     = 1.0,
            fullscreen_opacity = 1.0,

            blur = {
                enabled           = true,
                size              = 3,
                passes            = 4,
                new_optimizations = true,
                ignore_opacity    = true,
                xray              = true,
            },

            shadow = {
                enabled      = true,
                render_power = 2,
                color        = 0x50000000,
            },
        },

        -- Without this, toggleSplit()'s flip is recomputed away by
        -- recalcSizePosRecursive and the split dispatchers report ok while
        -- changing nothing.
        dwindle = {
            preserve_split = true,
        },
    })
end

return M
