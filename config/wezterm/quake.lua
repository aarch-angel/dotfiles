-- Pull in the wezterm API
local wezterm = require("wezterm")

-- Load default settings
local config = require("default")

-- Don't prompt to exit so that wezterm will actually close on shutdown
config.window_close_confirmation = "NeverPrompt"

-- set the window title so WTQ can find it
wezterm.on("format-window-title", function(tab, pane, tabs, panes, config) return "quaketerm" end)

return config
