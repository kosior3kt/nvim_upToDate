-- ~/.config/nvim/lua/jk/local_init.lua
local M = {}

function M.init()
  -- Get the correct base path for your specific structure
  local base_path = vim.fn.stdpath('config') .. '/lua/jk/local'
  base_path = vim.fn.substitute(base_path, '\\', '/', 'g')  -- Normalize path

  if vim.fn.isdirectory(base_path) == 0 then
    vim.notify("Local modules directory not found: " .. base_path, vim.log.levels.WARN)
    return
  end

  -- Get all .lua files except init.lua
  local files = vim.fn.glob(base_path .. '/*.lua', false, true)

  for _, file in ipairs(files) do
    local module_name = vim.fn.fnamemodify(file, ':t:r')
    if module_name ~= 'init' then
      -- Use the correct require path 'jk.local.module_name'
      local status, err = pcall(function()
        local mod = require('jk.local.' .. module_name)
        if type(mod) == 'table' and type(mod.setup) == 'function' then
          mod.setup()
        end
      end)

      if not status then
        vim.notify(string.format("Failed to load jk.local.%s: %s", module_name, err), vim.log.levels.ERROR)
      end
    end
  end
end

-- Auto-initialize
M.init()

return M
