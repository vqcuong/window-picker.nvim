local builder = require("window-picker.builder")
local default_config = require("window-picker.config")

local M = {}

function M.pick_window(custom_config)
  local config = default_config
  -- merge the config
  if custom_config then
    config = vim.tbl_deep_extend("force", config, custom_config)
  end
  return builder:new():set_config(config):build():pick_window()
end

function M.setup(opts)
  if opts then
    default_config = vim.tbl_deep_extend("force", default_config, opts)
  end

  -- Setting highlights at global level
  -- highlight config is deleted so hint classes will only receive the
  -- highlights from config passed to pick_window() function explicitly
  --
  -- Behaviour:
  -- WHEN user wants nether global nor default config, highlights can be
  -- disabled
  --
  -- WHEN global highlights are already set,
  --	IF pick_window() has no highlight config
  --		EXPECTED to use global highlights
  --	IF pick_window({highlights}) has highlight config
  --		EXPECTED to override only the passed highlights ONLY
  --
  -- WHEN global highlights are NOT set
  --	IF pick_window() has no highlight config
  --		EXPECTED to use default config highlights
  --	IF pick_window({highlights}) has highlight config
  --		EXPECTED to override only the passed highlights ONLY

  -- stylua: ignore
  if not default_config.highlights.enabled then return end
  M._create_hl_if_not_exists("WindowPickerStatusLine", default_config.highlights.statusline.focused)
  M._create_hl_if_not_exists("WindowPickerStatusLineNC", default_config.highlights.statusline.unfocused)
  M._create_hl_if_not_exists("WindowPickerWinBar", default_config.highlights.winbar.focused)
  M._create_hl_if_not_exists("WindowPickerWinBarNC", default_config.highlights.winbar.unfocused)
  default_config.highlights = { statusline = {}, winbar = {} }
end

-- stylua: ignore
function M._create_hl_if_not_exists(name, properties)
  if type(properties) ~= "table" then return end
  local hl = vim.api.nvim_get_hl(0, { name = name })
  if not vim.tbl_isempty(hl) then return end
  vim.api.nvim_set_hl(0, name, properties)
end

return M
