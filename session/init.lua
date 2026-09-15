-- Module registry and boot.
--
-- Order is the order of this list: options before the rules that read them,
-- binds last. Requires resolve through Hyprland's default package.path, which
-- already contains this config's directory.

local MODULES = {
    "options",
    "animations",
    "noctalia",
    "monitors",
    "autostart",
    "binds.apps",
    "binds.shell",
    "binds.media",
    "binds.windows",
    "binds.workspaces",
    "binds.system",
}

local CFG = {
    mod = "SUPER",
    ipc = "noctalia msg ",
}

local M = {}

function M.boot()
    for _, name in ipairs(MODULES) do
        -- A module that fails to parse is handed back as a stub table rather
        -- than raising, so a missing apply() is the only signal it went wrong.
        local mod = require("session." .. name)
        if type(mod) ~= "table" or type(mod.apply) ~= "function" then
            print(("[session] %s failed to load"):format(name))
        else
            local ok, err = pcall(mod.apply, CFG)
            if not ok then
                print(("[session] %s.apply: %s"):format(name, tostring(err)))
            end
        end
    end
end

return M
