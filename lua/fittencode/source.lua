local Base = require('fittencode.base')
local Engine = require('fittencode.engine')
local Log = require('fittencode.log')

-- types from nvim-cmp: `lua\cmp\types\cmp.lua`

---@class FittenSource
---@field trigger_characters string[]
local source = {}

---@return string[]
local function get_trigger_characters()
  local characters = {}
  for i = 32, 126 do
    characters[#characters + 1] = string.char(i)
  end
  characters[#characters + 1] = ' '
  characters[#characters + 1] = '\n'
  characters[#characters + 1] = '\r'
  characters[#characters + 1] = '\r\n'
  characters[#characters + 1] = '\t'
  return characters
end

---@param o FittenSource
---@return FittenSource
function source:new(o)
  o = o or {}
  o.trigger_characters = get_trigger_characters()
  setmetatable(o, self)
  self.__index = self
  return o
end

---@return string
function source:get_position_encoding_kind()
  return 'utf-8'
end

-- function source:get_keyword_pattern()
--   return '.*'
-- end

---@return string[]
function source:get_trigger_characters()
  return self.trigger_characters
end

local SOURCE_GENERATEONESTAGE_DEBOUNCE_TIME = 80

---@type uv_timer_t
local source_generate_one_stage_timer = nil

---Invoke completion (required).
---@param request cmp.SourceCompletionApiParams
---@param callback fun(response:lsp.CompletionResponse|nil)
function source:complete(request, callback)
  if not Engine.preflight() then
    callback()
    return
  end
  local row, col = Base.get_cursor()
  Base.debounce(source_generate_one_stage_timer, function()
    Engine.generate_one_stage(row, col, true, function(suggestions)
      local cursor_before_line = request.context.cursor_before_line:sub(request.offset)
      local line = request.context.cursor.line
      local character = request.context.cursor.character
      Log.debug('Request: {}', request)
      local response = Engine.convert_to_lsp_completion_response(line, character, cursor_before_line, suggestions)
      Log.debug('LSP CompletionResponse: {}', response)
      callback(response)
    end)
  end, SOURCE_GENERATEONESTAGE_DEBOUNCE_TIME)
end

return source