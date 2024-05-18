local wezterm = require("wezterm")
local config = wezterm.config_builder()

if wezterm.gui then
	local gpus = wezterm.gui.enumerate_gpus()
	config.webgpu_preferred_adapter = gpus[1]
	config.front_end = 'WebGpu'
end
return config
