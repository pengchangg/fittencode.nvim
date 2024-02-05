local uv = vim.uv

local Log = require('fittencode.log')

local M = {}

local DEFAULT_TIMEOUT = 1200
local DEFAULT_RECYCLING = 5000

M.tasks_list = {}
M.timeout_recycling_timer = nil

function M.setup()
  M.tasks_list = {}
  M.timeout_recycling_timer = uv.new_timer()
  M.timeout_recycling_timer:start(DEFAULT_RECYCLING, DEFAULT_RECYCLING, M.timeout_recycling)
end

function M.create(row, col)
  local timestamp = uv.hrtime()
  -- Log.debug('Creating task at row: ' .. row .. ', col: ' .. col .. ', timestamp: ' .. timestamp)
  table.insert(M.tasks_list, #M.tasks_list, { row = row, col = col, timestamp = timestamp })
  return timestamp
end

function M.match(task_id, row, col)
  for i, task in ipairs(M.tasks_list) do
    if task.timestamp == task_id and task.row == row and task.col == col then
      return true
    end
  end
  return false
end

function M.query(task_id)
  for i, task in ipairs(M.tasks_list) do
    if task.timestamp == task_id then
      return task
    end
  end
end

local function to_ms(ns)
  return ns / 1e6
end

function M.timeout_recycling()
  --   Log.debug('Timeout recycling tasks')
  for i, task in ipairs(M.tasks_list) do
    if to_ms(uv.hrtime() - task.timestamp) > DEFAULT_TIMEOUT then
      table.remove(M.tasks_list, i)
    end
  end
end

return M