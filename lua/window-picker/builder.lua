local dfilter = require("window-picker.filters.window-filter")
local dpicker = require("window-picker.pickers.window-picker")
local dconfigurer = require("window-picker.configurer")

--- @class DefaultBuilder
--- @field configurer Configurer
local M = {}

function M:new(configurer)
  local o = { configurer = configurer }

  setmetatable(o, self)
  self.__index = self

  return self
end

function M:set_config(config)
  self.config = config
  return self
end

function M:build()
  local configurer = dconfigurer:new(self.config)

  local supported_hints = { "floating-big-letter", "statusline-winbar", "statusline" }
  if type(self.config.hint) ~= "string" or not vim.tbl_contains(supported_hints, self.config.hint) then
    vim.notify("Hint is configured incorrectly, fallback to the default: statusline-winbar", vim.log.levels.WARN)
  end
  local dhint = require("window-picker.hints.%s"):format(self.config.hint)

  local hint = configurer:config_hint(dhint:new())
  local filter = configurer:config_filter(dfilter:new())
  local picker = configurer:config_picker(dpicker:new())

  picker:set_filter(filter)
  picker:set_hint(hint)
  return picker
end

return M
