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

-- The lowest workspace on this monitor that holds no windows.
--
-- Scanning for *existing* empty workspaces cannot work: Hyprland destroys a
-- workspace the moment its last window leaves it, so the only one that survives is
-- the monitor's own displayed workspace and a max_id+1 fallback then climbed on
-- every press. Scan for the lowest id that is neither occupied nor pinned to
-- another display instead, so a low id is reused as soon as its window moves away.
-- This is also why Hyprland's own "emptym" selector is unusable: it happily reuses
-- an empty workspace sitting on a different display.
local function lowest_free_workspace_on(mon)
    if not mon then
        return nil
    end

    local occupied, owner = {}, {}
    for _, w in ipairs(hl.get_workspaces()) do
        if not w.special then
            if w.windows > 0 then
                occupied[w.id] = true
            end
            if w.monitor then
                owner[w.id] = w.monitor.id
            end
        end
    end

    local id = 1
    while occupied[id] or (owner[id] and owner[id] ~= mon.id) do
        id = id + 1
    end

    return id
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
        local target = lowest_free_workspace_on(source_monitor())
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
