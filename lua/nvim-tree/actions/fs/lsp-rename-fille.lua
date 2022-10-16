local utils = require "nvim-tree.utils"
local events = require "nvim-tree.events"

local M = {}

local function err_fmt(from, to, reason)
  return string.format("Cannot rename %s -> %s: %s", from, to, reason)
end

function M.ts_rename(node, to)
  if utils.file_exists(to) then
    utils.notify.warn(err_fmt(node.absolute_path, to, "file already exists"))
    return
  end
  local ok, typescript = pcall(require, "typescript")
  if not ok or not typescript then
    return false
  end

  local result = typescript.renameFile(node.absolute_path, to)

  if not result then
    return false
  end

  utils.notify.info(node.absolute_path .. " ➜ " .. to)
  events._dispatch_node_renamed(node.absolute_path, to)

  return true
end

return M
