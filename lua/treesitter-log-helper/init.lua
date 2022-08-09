local ts_utils = require("nvim-treesitter.ts_utils")
local ts = require("nvim-treesitter")
local M = {}

local get_cursor_node = function()
  local node = ts_utils.get_node_at_cursor()
  if node == nil then
    error("No treesitter parser found")
  end
  return node
end

local function find_parent(pred, node)
  local parent = node:parent()
  if parent == nil then return nil end
  if pred(parent) then return parent end
  return find_parent(pred, parent)
end

local is_method_name = function(node)
  return node:type() == "method_definition"
end

M.run = function ()
  local cursor_node = get_cursor_node()
  local bufnr = vim.api.nvim_get_current_buf()
  local found = find_parent(is_method_name, cursor_node);

  if found ~= nil then
    local children = ts_utils.get_named_children(found)
    for k, v in pairs(children) do
      if v:type() == "property_identifier" then
        local val = vim.fn.expand('%:t') .. "#" ..vim.treesitter.query.get_node_text(v, bufnr)

        local pos = vim.api.nvim_win_get_cursor(0)[2]
        local line = vim.api.nvim_get_current_line()
        local nline = line:sub(0, pos) .. ' console.log("' .. val .. '");'.. line:sub(pos + 1)
        vim.api.nvim_set_current_line(nline)

        return
      end
    end
  end
end


-- look up the tree for a function definition or a method declaration
-- if the root node is found, print "Not in a function or a method
-- if one of these is found, print the method name and the file name

vim.keymap.set('n', '<leader>fl', ':lua require"treesitter-log-helper".run()<cr>')

return M
