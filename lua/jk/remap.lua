vim.g.mapleader = " "
--vim.keymap.set("n", "<leader>fv", vim.cmd.Ex, {desc = "open project tree"})
vim.keymap.set("n", "<leader>fv", ":Oil<CR>", {desc = "open project tree in Oil"})

vim.keymap.set("n", "<leader>bn", ":bn<CR>", {desc = "next buffer"})
vim.keymap.set("n", "<leader>bp", ":bp<CR>", {desc = "previous buffer"})
vim.keymap.set("n", "<leader>bd", ":bd<CR>", {desc = "close buffer"})

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("n", "<C-k>", "<cmd>cprev<CR>zz", {desc = "Go to the previoud error"})
vim.keymap.set("n", "<C-j>", "<cmd>cnext<CR>zz", {desc = "Go to the next error"})
vim.keymap.set("n", "<leader>k", "<cmd>lprev<CR>zz", {desc = "Go to next item from location list"})
vim.keymap.set("n", "<leader>j", "<cmd>lnext<CR>zz", {desc = "Go to previous item from location list"})


vim.keymap.set("n", "g:", ":<C-f>", {desc = "Open command menu"})

vim.keymap.set("n", "<leader>wh", "<C-w>h", {desc = "Go to the window left"})
vim.keymap.set("n", "<leader>wj", "<C-w>j", {desc = "Go to the window up"})
vim.keymap.set("n", "<leader>wk", "<C-w>k", {desc = "Go to the window down"})
vim.keymap.set("n", "<leader>wl", "<C-w>l", {desc = "Go to the window right"})
vim.keymap.set("n", "<leader>ws", "<C-w>s", {desc = "Open vertical window"})
vim.keymap.set("n", "<leader>wv", "<C-w>v", {desc = "Open horizontal window"})
vim.keymap.set("n", "<leader>ww", "<C-w>c", {desc = "Close window"})
vim.keymap.set("n", "<leader>wT", "<C-w>T", {desc = "Break window into separate tab"})

vim.keymap.set("n", "<leader>i", "`^", {desc = "Go to last insert"})
vim.keymap.set("v", "<leader>i", "`^", {desc = "Go to last insert"})

vim.keymap.set("n", "<leader>]", "<C-]>", {desc = "go to mark under cursor"})
vim.keymap.set("n", "<leader>g]", "g<C-]>", {desc = "go to mark under cursor"})

vim.keymap.set("n", "<leader>on", ":ObsidianNew", {desc = "Create new obsidian note"})
vim.keymap.set("n", "<leader>oo", ":ObsidianOpen <CR>", {desc = "Open obsidian note in Obsidian App"})
vim.keymap.set("n", "<leader>or", ":ObsidianBacklinks <CR>", {desc = "Open list of references to this note"})
vim.keymap.set("n", "<leader>ot", ":ObsidianTags <CR>", {desc = "Open list of tags"})
vim.keymap.set("n", "<leader>ol", ":ObsidianLink", {desc = "Link selection to note"})
vim.keymap.set("n", "<leader>ov", ":ObsidianTOC <CR>", {desc = "TOC of current note"})

vim.keymap.set("v", "gy", "ygv<Esc>", {desc = "copies selection without moving the the cursor"})
vim.keymap.set("n", "gl", "$", {desc = "$ replacement"})
vim.keymap.set("n", "gh", "_", {desc = "_ replacement"})
vim.keymap.set("v", "gl", "$", {desc = "$ replacement"})
vim.keymap.set("v", "gh", "_", {desc = "_ replacement"})


vim.keymap.set("n", "'", "`") -- cmon, this shuold be the deafult behaviour...

vim.opt.colorcolumn = "80"
local y = false
vim.keymap.set("n", "<leader>sl", function()
	if y then
		vim.opt.colorcolumn = "80"
		y = false
	else
		vim.opt.colorcolumn = ""
		y = true
	end
end, {desc = "toggle colorcolumn"})

-- vim.keymap.set("n", "<leader>sc", ":TSContext<CR>3<CR>", {desc = "toggle context"})
vim.keymap.set("n", "<leader>sc",
function()
      require("treesitter-context").toggle()
    end
, {desc = "toggle context"})


-- this is ugly, but I dont give a fuck
vim.keymap.set("n", "<leader><leader>", function()
    local current_file = vim.fn.expand('%:p')
    local notes_path = vim.fn.expand('~/notes/quick_note.md')
    current_file = vim.fn.resolve(vim.fn.fnamemodify(current_file, ':p'))
    notes_path = vim.fn.resolve(vim.fn.fnamemodify(notes_path, ':p'))
	-- make sure it's fucking full path
    if current_file == notes_path then
        if vim.bo.modified then
            vim.cmd('w')
        end
        vim.cmd('bd')
        print("Saved and returned to previous buffer from quick note")
    else
        local existing_bufnr = nil
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_get_option(buf, 'buflisted') then
                local buf_path = vim.fn.resolve(vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ':p'))
                if buf_path == notes_path then
                    existing_bufnr = buf
                    break
                end
            end
        end
        if existing_bufnr then
            vim.cmd('buffer ' .. existing_bufnr)
        else
            vim.cmd('edit ' .. notes_path)
        end
        print("Switched to quick note from: " .. vim.fn.fnamemodify(current_file, ':~'))
    end
end, {desc = "Toggle quick notes buffer"})




-- for now I dont need this since all the usage would be with quickfix anyways
-- update: now handles both qf and ll
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "qf" },
    callback = function()
        local is_loclist = false
        for _, win in ipairs(vim.fn.getwininfo()) do
            if win.loclist == 1 and win.tabnr == vim.fn.tabpagenr() then
                is_loclist = true
                break
            end
        end

        local close_cmd = is_loclist and ":lclose<CR>" or ":cclose<CR>"
        vim.keymap.set("n", "<CR>", "<CR>" .. close_cmd, { buffer = true, noremap = true, silent = true })
    end,
})


-- this is for highlighting the whitespaces at the end of the line
vim.cmd[[hi EoLSpace ctermbg=238 guibg=#696969]]
vim.cmd[[match EoLSpace /\s\+$/]]
trailing_is_set = true
vim.keymap.set("n", "<leader>sw", function()
	if trailing_is_set == false then
		vim.cmd[[match EoLSpace /\s\+$/]]
		trailing_is_set = true;
		print("trailing space detection is ON")
	else
		vim.cmd[[match EoLSpace /vbnluiawebg\s\+poiugawgoaw/]]
		trailing_is_set = false;
		print("trailing space detection is OFF")
	end
end, {desc = "toggles visibility of trailing whitespaces"}
)

-- --- folding in c
-- function _G.c_style_fold(lnum)
--     local line = vim.fn.getline(lnum) -- Get the current line text
--
--     if line:match("^/%*") then
-- 		if line:match("%*/$") then
-- 			return "="	-- if this is one line comment ignore it
-- 		else
-- 			return "a1" -- else start of fold
-- 		end
--     elseif line:match("%*/$") then
-- 		return "s1"	--end of fold
--     else
-- 		return "="  --maintain fold level
--     end
-- end
--
-- -- Set foldmethod and foldexpr in Lua
-- vim.api.nvim_create_autocmd("FileType", {
--     pattern = { "c", "cpp" },
--     callback = function()
--         vim.opt_local.foldmethod = "expr"
--         vim.opt_local.foldexpr = "v:lua._G.c_style_fold(v:lnum)"
-- 		vim.cmd[[:highlight Folded guibg='#111111' guifg=DarkGreen ]]
-- 		vim.cmd[[normal! zi]]
--     end,
-- })

-- get to the last edit in file
vim.api.nvim_create_autocmd('BufReadPost', {
  desc = 'Open file at the last position it was edited earlier',
  group = misc_augroup,
  pattern = '*',
  command = 'silent! normal! g`"zv'
})


-- this one is for populating location list with my garbage
function _G.search_non_numbered_underscored_words()
    local bufnr = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local results = {}

    for lnum, line in ipairs(lines) do
        local pos = 1
        while true do
            local start1, end1 = line:find("__", pos)
            if not start1 then break end
            local start2, end2 = line:find("__", end1 + 1)
            if not start2 then break end
            local content = line:sub(end1 + 1, start2 - 1)
            local before = line:sub(1, start1 - 1)
            if not before:match("%d%)%s*$") then
                table.insert(results, {
                    bufnr = bufnr,
                    lnum = lnum,
                    col = start1 - 1,
                    text = "__"..content.."__"
                })
            end
            pos = end2 + 1
        end
    end

    if #results == 0 then
        print("No matches found!")
        return
    end

    vim.fn.setloclist(0, results, "r")
    vim.cmd("lopen")
end


vim.keymap.set("n", "<leader>gO", _G.search_non_numbered_underscored_words, { noremap = true, silent = true })

function _G.search_sections()
    local bufnr = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local results = {}

    for lnum, line in ipairs(lines) do
        local start, _, section = line:find("/////+%s*(.*)")
        if start then
            table.insert(results, {
                bufnr = bufnr,
                lnum = lnum,
                col = start - 1,
                text = section
            })
        end
    end

    if #results == 0 then
        print("No matches found!")
        return
    end

    vim.fn.setloclist(0, results, "r")
    vim.cmd("lopen")
end

vim.keymap.set("n", "<leader>go", _G.search_sections, { noremap = true, silent = true })

local function load_external_paths()
	local file = io.open("libs.json", "r")
	if not file then return end
	local data = file:read("*all")
	file:close()
	local json = vim.fn.json_decode(data)

	local counter = 0
	for _, path in ipairs(json.libraries) do
		vim.opt.path:append(vim.fn.expand(path))
		vim.opt.tags:append(vim.fn.expand(path .. "/tags"))
		counter = counter + 1
	end
	print("loaded",counter, "paths")
end


vim.keymap.set("n", "<leader>ll", load_external_paths, {desc = "searches for libs.json files loads path from there to lsp"})

vim.opt.tags:prepend("~/.config/nvim/external_tags")


vim.keymap.set("n", "<leader>sh", ":nohl<CR>", { desc="clears search results", silent = true })

vim.keymap.set("n", "gr", "g<C-]>2<CR><CR>", { desc="jumps to implementation if available", silent = true })

-- vim.keymap.set("n", "K", "<cmd>horizontal help <C-r><C-w><CR>", { silent = true })

local function remove_trailing_whitespaces()
  -- 1. Save cursor position
  local cursor_pos = vim.api.nvim_win_get_cursor(0)

  -- 2. Get all lines
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

  -- 3. Process lines (fixed your accumulation)
  local cleaned_lines = {}
  for i, line in ipairs(lines) do
    cleaned_lines[i] = line:gsub('%s+$', '')
  end

  -- 4. Create undo chunk (all changes as single operation)
  vim.api.nvim_buf_set_option(0, 'undolevels', vim.api.nvim_buf_get_option(0, 'undolevels'))

  -- 5. Apply changes atomically
  vim.api.nvim_buf_set_lines(0, 0, -1, false, cleaned_lines)

  -- 6. Restore cursor (with column clamping)
  local new_line = math.min(cursor_pos[1], #cleaned_lines)
  local new_col = math.min(cursor_pos[2], #cleaned_lines[new_line] or 0)
  vim.api.nvim_win_set_cursor(0, {new_line, new_col})
end

-- Create a command that shows in undo history
vim.keymap.set('n', '<leader>st',remove_trailing_whitespaces, {desc = 'remove trailing whitespaces'})

vim.keymap.set("n", "[c", function()
  require("treesitter-context").go_to_context(vim.v.count1)
end, { silent = true, desc = "jump to context" })

vim.keymap.set('n', 'zR', function() require('ufo').openAllFolds() end, { desc = 'Open all folds' })
vim.keymap.set('n', 'zM', function() require('ufo').closeAllFolds() end, { desc = 'Close all folds' })
vim.keymap.set('n', 'zm', function() require('ufo').closeFoldsWith() end, { desc = 'Close folds recursively' }) -- This is the recursive closer
vim.keymap.set('n', 'zr', function() require('ufo').openFoldsExceptKinds() end, { desc = 'Open folds incrementally' })
vim.keymap.set('n', 'zp', function() require('ufo').peekFoldedLinesUnderCursor() end, { desc = 'Peek fold' })
