-- Window focus, movement, resize, layout and mode toggles.

local M = {}

-- Steps are taken from the monitor, not the window: a window-relative step
-- would shrink with the window on every press.
local RESIZE_STEP = 0.10

local function resize(axis, sign)
    local win = hl.get_active_window()
    if not win then
        return
    end

    local mon = win.monitor or hl.get_active_monitor()
    if not mon then
        return
    end

    local basis = (axis == "x") and mon.width or mon.height
    local d     = math.max(1, math.floor(basis * RESIZE_STEP)) * sign

    local dx, dy = 0, 0
    if axis == "x" then
        dx = d
    else
        dy = d
    end

    hl.dispatch(hl.dsp.window.resize({ x = dx, y = dy, relative = true }))

    -- Hyprland centres the growth (-delta/2), so undo it to hold the top-left.
    -- Tiled windows ignore position moves entirely and need no correction.
    if win.floating then
        hl.dispatch(hl.dsp.window.move({ x = dx / 2, y = dy / 2, relative = true }))
    end
end

function M.apply(cfg)
    local mod = cfg.mod

    hl.bind(mod .. " + A", hl.dsp.focus({ direction = "left" }))
    hl.bind(mod .. " + D", hl.dsp.focus({ direction = "right" }))
    hl.bind(mod .. " + W", hl.dsp.focus({ direction = "up" }))
    hl.bind(mod .. " + S", hl.dsp.focus({ direction = "down" }))

    hl.bind(mod .. " + CTRL + A", hl.dsp.window.move({ direction = "left" }))
    hl.bind(mod .. " + CTRL + D", hl.dsp.window.move({ direction = "right" }))
    hl.bind(mod .. " + CTRL + W", hl.dsp.window.move({ direction = "up" }))
    hl.bind(mod .. " + CTRL + S", hl.dsp.window.move({ direction = "down" }))

    hl.bind("CTRL + ALT + A", hl.dsp.focus({ monitor = "l" }))
    hl.bind("CTRL + ALT + D", hl.dsp.focus({ monitor = "r" }))
    hl.bind("CTRL + ALT + W", hl.dsp.focus({ monitor = "u" }))
    hl.bind("CTRL + ALT + S", hl.dsp.focus({ monitor = "d" }))

    -- No `window` argument: these act on the focused window, and omitting the
    -- selector avoids the string-selector pitfall entirely.
    hl.bind(mod .. " + ALT + A", function() resize("x", -1) end)
    hl.bind(mod .. " + ALT + D", function() resize("x",  1) end)
    hl.bind(mod .. " + ALT + W", function() resize("y", -1) end)
    hl.bind(mod .. " + ALT + S", function() resize("y",  1) end)

    hl.bind(mod .. " + Left",  hl.dsp.window.resize({ x = -100, y = 0,   relative = true }))
    hl.bind(mod .. " + Right", hl.dsp.window.resize({ x =  100, y = 0,   relative = true }))
    hl.bind(mod .. " + Up",    hl.dsp.window.resize({ x = 0,    y = -100, relative = true }))
    hl.bind(mod .. " + Down",  hl.dsp.window.resize({ x = 0,    y =  100, relative = true }))

    hl.bind(mod .. " + comma",  hl.dsp.layout("togglesplit"))
    hl.bind(mod .. " + period", hl.dsp.layout("swapsplit"))
    hl.bind(mod .. " + J",      hl.dsp.layout("togglesplit"))
    hl.bind(mod .. " + K",      hl.dsp.layout("swapsplit"))
    hl.bind(mod .. " + R",      hl.dsp.layout("togglesplit"))

    hl.bind(mod .. " + C",       hl.dsp.window.center())
    hl.bind(mod .. " + CTRL + C", hl.dsp.window.center())

    hl.bind(mod .. " + T",         hl.dsp.window.float({ action = "toggle" }))
    hl.bind(mod .. " + F",         hl.dsp.window.fullscreen({ mode = "maximized" }))
    hl.bind(mod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
    hl.bind(mod .. " + M",         hl.dsp.window.fullscreen({ mode = "maximized" }))
    hl.bind(mod .. " + CTRL + Tab", hl.dsp.group.toggle())
end

return M
