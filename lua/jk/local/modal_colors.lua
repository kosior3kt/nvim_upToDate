-- ~/.config/nvim/lua/local/mode_colors.lua
local M = {}

-- Store original colors
local original_colors = {
    CursorLineNr = vim.api.nvim_get_hl(0, {name = 'CursorLineNr'}),
    CursorLine = vim.api.nvim_get_hl(0, {name = 'CursorLine'}),
    CursorColumn = vim.api.nvim_get_hl(0, {name = 'CursorColumn'}),
    ColorColumn = vim.api.nvim_get_hl(0, {name = 'ColorColumn'}),
    Visual = vim.api.nvim_get_hl(0, {name = 'Visual'})
}

-- Mode-specific colors (only what should CHANGE)
M.colors = {
    insert = {
        linenr = "#229c5f",  -- Green for insert
        cursorline = "#0b2d01",
        cursorcolumn = "#0b2d01",
        colorcolumn = "#0b2d01"
    },
    command = {
        linenr = "#aa7799",  -- Purple for command
        cursorline = "#403804",
        cursorcolumn = "#403804",
        colorcolumn = "#403804"
    },
    visual = {
        linenr = "#a234b3",  -- Purple for visual
        cursorline = "#400431",
        cursorcolumn = "#400431",
        colorcolumn = "#400431",
        visual_bg = "#5E3D6E",
        visual_fg = "#FFFFFF"
    },
    replace = {
        linenr = "#C678DD",  -- Magenta for replace
        cursorline = "#30032f",
        cursorcolumn = "#30032f",
        colorcolumn = "#30032f"
    }
}

-- Track the last applied mode to avoid unnecessary updates
local last_applied_mode = nil

local function apply_mode_colors(mode)
    -- Only update if the mode has actually changed
    if mode == last_applied_mode then return end
    last_applied_mode = mode

    -- Always restore original line numbers first
    vim.api.nvim_set_hl(0, 'CursorLineNr', original_colors.CursorLineNr)

    -- Apply mode-specific colors if not normal mode
    if mode ~= "normal" then
        local colors = M.colors[mode]
        if colors then
            -- Apply line number color if specified
            if colors.linenr then
                local new_linenr = vim.tbl_extend("force", 
                    original_colors.CursorLineNr,
                    {fg = colors.linenr}
                )
                vim.api.nvim_set_hl(0, 'CursorLineNr', new_linenr)
            end

            -- Apply other highlights
            vim.api.nvim_set_hl(0, 'CursorLine', {bg = colors.cursorline})
            vim.api.nvim_set_hl(0, 'CursorColumn', {bg = colors.cursorcolumn})
            vim.api.nvim_set_hl(0, 'ColorColumn', {bg = colors.colorcolumn})

            if mode == "visual" then
                vim.api.nvim_set_hl(0, 'Visual', {
                    bg = colors.visual_bg,
                    fg = colors.visual_fg
                })
            end
        end
    else
        -- Restore all original colors for normal mode
        vim.api.nvim_set_hl(0, 'CursorLine', {bg = original_colors.CursorLine.bg})
        vim.api.nvim_set_hl(0, 'CursorColumn', {bg = original_colors.CursorColumn.bg})
        vim.api.nvim_set_hl(0, 'ColorColumn', {bg = original_colors.ColorColumn.bg})
        vim.api.nvim_set_hl(0, 'Visual', original_colors.Visual)
    end
end

local function get_current_mode()
    local mode = vim.fn.mode()
    local mode_map = {
        ['n'] = 'normal',
        ['i'] = 'insert',
        ['v'] = 'visual',
        ['V'] = 'visual',
        [''] = 'visual',
        ['R'] = 'replace',
        ['c'] = 'command',
        ['t'] = 'insert'  -- Treat terminal mode like insert mode
    }
    return mode_map[mode] or 'normal'
end

local function setup_autocommands()
    local group = vim.api.nvim_create_augroup('ModeColors', {clear = true})

    -- Main mode change handler
    vim.api.nvim_create_autocmd('ModeChanged', {
        group = group,
        pattern = '*:*',
        callback = function()
            apply_mode_colors(get_current_mode())
        end
    })

    -- Update colors when buffer changes
    vim.api.nvim_create_autocmd({'BufEnter', 'BufWinEnter'}, {
        group = group,
        callback = function()
            -- Add a small delay to ensure mode has stabilized after buffer change
            vim.defer_fn(function()
                apply_mode_colors(get_current_mode())
            end, 10)
        end
    })

    -- Update colors after leaving Telescope
    vim.api.nvim_create_autocmd('User', {
        group = group,
        pattern = 'TelescopePreviewerLoaded',
        callback = function()
            apply_mode_colors(get_current_mode())
        end
    })

    vim.api.nvim_create_autocmd('User', {
        group = group,
        pattern = 'TelescopePreviewerClosed',
        callback = function()
            apply_mode_colors(get_current_mode())
        end
    })

    -- Capture initial colors after colorscheme loads
    vim.api.nvim_create_autocmd('ColorScheme', {
        group = group,
        callback = function()
            original_colors.CursorLineNr = vim.api.nvim_get_hl(0, {name = 'CursorLineNr'})
            original_colors.CursorLine = vim.api.nvim_get_hl(0, {name = 'CursorLine'})
            original_colors.CursorColumn = vim.api.nvim_get_hl(0, {name = 'CursorColumn'})
            original_colors.ColorColumn = vim.api.nvim_get_hl(0, {name = 'ColorColumn'})
            original_colors.Visual = vim.api.nvim_get_hl(0, {name = 'Visual'})
            apply_mode_colors(get_current_mode())
        end
    })

    -- Initial setup
    vim.defer_fn(function()
        apply_mode_colors(get_current_mode())
    end, 100)
end

function M.setup(user_config)
    if user_config then
        M.colors = vim.tbl_deep_extend('force', M.colors, user_config)
    end
    setup_autocommands()
end

return M
