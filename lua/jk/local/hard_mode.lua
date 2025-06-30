-- ~/.config/nvim/lua/local/hard_mode.lua
local M = {}

local last_key = ''
local num_of_repetions = 0
local enabled = true

local function check_repeat(key)
  if not enabled then return false end

  -- These keys are allowed to repeat
  local allowed_keys = {
    ['<CR>'] = true, ['<Tab>'] = true, ['<Space>'] = true,
    ['<BS>'] = true, ['<Del>'] = true, ['<Esc>'] = true,
    ['<Up>'] = true, ['<Down>'] = true, ['<Left>'] = true, ['<Right>'] = true,
    ['u'] = true, ['n'] = true, ['N'] = true, [']'] = true, ['['] = true, ['{'] = true,
	['}'] = true, ['g'] = true, [';'] = true, ['0'] = true, ['1'] = true,
	['2'] = true, ['3'] = true, ['4'] = true, ['5'] = true, ['6'] = true,
	['7'] = true, ['8'] = true, ['9'] = true, ['J'] = true, ['p'] = true, ['P'] = true,
 }

  if allowed_keys[key] then
    last_key = key
    return false
  end

  if key:match('^F%d+$') then  -- Function keys F1-F12
    last_key = key
    return false
  end

  if key == last_key then
	if num_of_repetions >= 2 then
		vim.notify("Don't repeat keys!", vim.log.levels.WARN)
		return true
	else
		num_of_repetions = num_of_repetions + 1
	end
  else
	num_of_repetions = 0
	last_key = key
  end

  return false
end

function M.toggle()
  enabled = not enabled
  vim.notify("Hard mode " .. (enabled and "ENABLED" or "DISABLED"),
    enabled and vim.log.levels.WARN or vim.log.levels.INFO)
end

function M.setup()
  -- Setup normal mode mappings
  for i = 32, 126 do  -- All printable ASCII characters
    local char = string.char(i)
    vim.keymap.set('n', char, function()
      return check_repeat(char) and '' or char
    end, {expr = true, silent = true})
  end

  -- Setup special keys
  local special_keys = {
    '<CR>', '<Tab>', '<Space>', '<BS>', '<Del>', '<Esc>',
    '<Up>', '<Down>', '<Left>', '<Right>'
  }
  for _, key in ipairs(special_keys) do
    vim.keymap.set('n', key, function()
      return check_repeat(key) and '' or key
    end, {expr = true, silent = true})
  end

  -- Reset when changing modes
  vim.api.nvim_create_autocmd({'ModeChanged'}, {
    callback = function()
      last_key = ''
    end
  })

  -- Toggle mapping
  vim.keymap.set('n', '<leader>sr', M.toggle, {desc = 'Toggle key repeat restriction'})
end

return M
