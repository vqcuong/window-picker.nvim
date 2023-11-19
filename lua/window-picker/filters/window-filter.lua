local util = require("window-picker.util")

--- @class DefaultWindowFilter
--- @field filter_stack function[]
--- @field filter_func function?
--- @field window_options table<string, any> window options to filter
--- @field buffer_options table<string, any> buffer options to filter
--- @field file_name_contains string[] file names to filter
--- @field file_path_contains string[] file paths to filter
local M = {}

function M:new()
  local o = {}

  setmetatable(o, self)
  self.__index = self

  o.filter_stack = {
    o._window_option_filter,
    o._buffer_options_filter,
    o._current_window_filter,
  }

  return o
end

function M:set_config(filter_config)
  self.filter_func = filter_config.filter_func or nil
  self.excluded_window_opts = filter_config.excluded.window_opts or {}
  self.excluded_buffer_opts = filter_config.excluded.buffer_opts or {}
  self.include_current_win = filter_config.include_current_win
end

function M:filter_windows(windows)
  if self.filter_func ~= nil then
    vim.notify("use filter_func")
    return self.filter_func(windows)
  end
  local filtered_windows = windows
  for _, filter in ipairs(self.filter_stack) do
    filtered_windows = filter(self, filtered_windows)
  end
  return filtered_windows
end

function M:_window_option_filter(windows)
  if self.excluded_window_opts and vim.tbl_count(self.excluded_window_opts) > 0 then
    return util.tbl_filter(windows, function(winid)
      for opt_key, opt_values in pairs(self.excluded_window_opts) do
        local actual_opt = vim.api.nvim_win_get_option(winid, opt_key)
        local has_value = vim.tbl_contains(opt_values, actual_opt)
        if has_value then
          return false
        end
      end
      return true
    end)
  else
    return windows
  end
end

function M:_buffer_options_filter(windows)
  if self.excluded_buffer_opts and vim.tbl_count(self.excluded_buffer_opts) > 0 then
    return util.tbl_filter(windows, function(winid)
      local bufid = vim.api.nvim_win_get_buf(winid)
      for opt_key, opt_values in pairs(self.excluded_buffer_opts) do
        local actual_opt = vim.api.nvim_buf_get_option(bufid, opt_key)
        local has_value = vim.tbl_contains(opt_values, actual_opt)
        if has_value then
          return false
        end
      end
      return true
    end)
  else
    return windows
  end
end

function M:_current_window_filter(windows)
  if self.include_current_win then
    return windows
  end
  local curr_win = vim.api.nvim_get_current_win()
  return util.tbl_filter(windows, function(winid)
    return winid ~= curr_win
  end)
end

return M
