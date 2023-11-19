---@class Configurer
---@field config any
local M = {}

function M:new(config)
  config = M._basic_config_manipulations(config)

  local o = {
    config = config,
  }

  setmetatable(o, self)
  self.__index = self

  return o
end

function M._basic_config_manipulations(config)
  config.chars = M._str_to_char_list(config.selection_chars)
  return config
end

function M:config_filter(filter)
  filter:set_config(self.config.filter)
  return filter
end

function M:config_hint(hint)
  hint:set_config(self.config)
  return hint
end

function M:config_picker(picker)
  picker:set_config(self.config)
  return picker
end

-- stylua: ignore
function M._str_to_char_list(str)
  local char_list = {}
  for i = 1, #str do table.insert(char_list, str:sub(i, i)) end
  return char_list
end

return M
