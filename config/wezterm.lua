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

config.colors = {
    foreground = "#ffffff",
    background = "#0A0A0A",
    cursor_bg = "#6D6D6D",
    cursor_fg = "#6D6D6D",
    cursor_border = "#6D6D6D",
    selection_fg = "#ffffff",
    selection_bg = "#B91D73",
    ansi = {
        "#181818", -- Black
        "#B91D73", -- Red
        "#35B91D", -- Green
        "#F9F9F8", -- Yellow
        "#1E1E1E", -- Blue
        "#B91D73", -- Magenta
        "#76A8A8", -- Cyan
        "#ffffff"  -- White
    },
    brights = {
        "#2E3436", -- Bright Black
        "#B91D73", -- Bright Red
        "#65B91D", -- Bright Green
        "#FFFFFF", -- Bright Yellow
        "#2882F9", -- Bright Blue
        "#B91D73", -- Bright Magenta
        "#A1C8C8", -- Bright Cyan
        "#ffffff"  -- Bright White
    }
}

config.window_background_opacity = 0.8
config.macos_window_background_blur = 25
config.window_padding = {
    left = 10,
    right = 10,
    top = 10,
    bottom = 10,
}

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

wezterm.on("trigger-helix-with-scrollback", function(window)
    local overrides = window:get_config_overrides() or {}
    overrides.window_padding = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 0,
    }
    window:set_config_overrides(overrides)

    local dims = window:get_dimensions()
    local pad = 5
    window:set_inner_size({
        width = dims.pixel_width + 2 * pad,
        height = dims.pixel_height + 2 * pad,
    })
end)

wezterm.on("trigger-helix-without-scrollback", function(window)
    window:set_config_overrides({
        window_padding = {
            left = 10,
            right = 10,
            top = 10,
            bottom = 10,
        },
    })
end)

return config
