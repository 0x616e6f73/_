local wezterm = require("wezterm")

local config = {}

if wezterm.gui then
    local gpus = wezterm.gui.enumerate_gpus()
    config.webgpu_preferred_adapter = gpus[1]
    config.front_end = 'WebGpu'
end

config.font = wezterm.font("MesloLGS NF", { weight = "Regular" })
config.font_size = 13.0
config.bold_brightens_ansi_colors = true
config.color_scheme = 'Glacier'
config.colors = {
    -- Normally #0a0a0a when going transparent
    background = "#151515" -- Default background color
}
config.window_background_opacity = 0.8
config.macos_window_background_blur = 25
config.window_padding = {
    left = 10,
    right = 10,
    top = 10,
    bottom = 10,
}

local function update_appearance(window, pane)
    local overrides = window:get_config_overrides() or {}
    local foreground_process = pane:get_foreground_process_name()
    if foreground_process:find("hx") then
        overrides.window_background_opacity = 1.0
        overrides.colors = { background = "#151515" }
        overrides.window_padding = {
            left = 0,
            right = 0,
            top = 0,
            bottom = 0,
        }
    else
        -- Normally this would be #0a0a0a @ 0.8, but I'm switching off of transparency while I rebuild the full dev suite
        overrides.window_background_opacity = 1.0
        overrides.colors = { background = "#151515" }
        overrides.window_padding = {
            left = 10,
            right = 10,
            top = 10,
            bottom = 10,
        }
    end
    window:set_config_overrides(overrides)
end

wezterm.on("update-right-status", function(window, pane)
    update_appearance(window, pane)
end)

config.window_close_confirmation = "NeverPrompt"
config.adjust_window_size_when_changing_font_size = false
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.show_tab_index_in_tab_bar = false
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.cursor_blink_rate = 500
config.default_cursor_style = "SteadyBar"
config.scrollback_lines = 1000
config.use_dead_keys = false
config.window_decorations = "RESIZE"
config.default_prog = { "zsh", "-l" }
config.term = "xterm-256color"

return config
