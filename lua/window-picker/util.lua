local M = {}

function M.tbl_filter(tbl, filter_func)
  return vim.tbl_filter(filter_func, tbl)
end

-- stylua: ignore
function M.get_user_input_char()
  local ok, c = pcall(vim.fn.getchar)
  if not ok then return end
  while type(c) ~= "number" do c = vim.fn.getchar() end
  return vim.fn.nr2char(c)
end

function M.clear_prompt()
  vim.api.nvim_command("normal :esc<CR>")
end

-- stylua: ignore
function M.merge_config(current_config, new_config)
  if not new_config then return current_config end
  return vim.tbl_deep_extend("force", current_config, new_config)
end

-- stylua: ignore
function M.is_float(window)
  local config = vim.api.nvim_win_get_config(window)
  return config.relative ~= ""
end

return M
