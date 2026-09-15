-- Workspaces: focus, single-window send, whole-workspace send, arrow sends.

local M = {}

local function workspace_ids_on(mon)
    local ids = {}
    if not mon then
        return ids
    end

    for _, w in ipairs(hl.get_workspaces()) do
        if not w.special and w.monitor and w.monitor.id == mon.id then
            ids[#ids + 1] = w.id
        end
    end

    table.sort(ids)
    return ids
end

-- The focused window's monitor, which is what Hyprland's own selectors resolve
-- against; the monitor under the pointer is only the no-window fallback.
local function source_monitor()
    local win = hl.get_active_window()
    if win and win.monitor then
        return win.monitor
    end

    return hl.get_active_monitor()
end

local function send_active_to(ws_id)
    hl.dispatch(hl.dsp.window.move({ window = hl.get_active_window(), workspace = ws_id }))
end

local function move_workspace_to(target)
    local ws = hl.get_active_workspace()
    if not ws then
        return
    end

    -- The window OBJECT must be passed: a bare address string returns ok and
    -- moves nothing.
    for _, w in ipairs(hl.get_workspace_windows(ws.id)) do
        hl.dispatch(hl.dsp.window.move({ window = w, workspace = target }))
    end

    hl.dispatch(hl.dsp.focus({ workspace = target }))
end

-- The lowest empty workspace belonging to this monitor. Hyprland's "emptym"
-- selector is unusable here: it reuses an empty workspace sitting on another
-- display, which defeats the point of the bind.
local function empty_workspace_on(mon)
    if not mon then
        return nil
    end

    local used, empty_here, max_id = {}, {}, 0
    for _, w in ipairs(hl.get_workspaces()) do
        if not w.special then
            used[w.id] = true
            if w.id > max_id then
                max_id = w.id
            end
            if w.monitor and w.monitor.id == mon.id and w.windows == 0 then
                empty_here[#empty_here + 1] = w.id
            end
        end
    end

    table.sort(empty_here)
    if empty_here[1] then
        return empty_here[1]
    end

    local fresh = math.max(max_id + 1, 4)
    while used[fresh] do
        fresh = fresh + 1
    end

    return fresh
end

function M.apply(cfg)
    local mod = cfg.mod

    for i = 1, 9 do
        hl.bind(mod .. " + " .. i, hl.dsp.focus({ workspace = i }))
        hl.bind(mod .. " + CTRL + " .. i, hl.dsp.window.move({ workspace = i }))
        hl.bind(mod .. " + SHIFT + " .. i, function()
            move_workspace_to(i)
        end)
    end

    hl.bind(mod .. " + SHIFT + Tab", hl.dsp.focus({ workspace = "m-1" }))
    hl.bind("CTRL + ALT + Tab",      hl.dsp.focus({ workspace = "m+1" }))

    hl.bind(mod .. " + CTRL + Down", function()
        local target = empty_workspace_on(source_monitor())
        if target then
            send_active_to(target)
        end
    end)

    -- First and last workspace that exists on this monitor. A single workspace
    -- resolves both to itself, so the window never crosses displays.
    for _, spec in ipairs({ { "Left", 1 }, { "Right", -1 } }) do
        hl.bind(mod .. " + CTRL + " .. spec[1], function()
            local ids    = workspace_ids_on(source_monitor())
            local target = (spec[2] == 1) and ids[1] or ids[#ids]
            if target then
                send_active_to(target)
            end
        end)
    end
end

return M
