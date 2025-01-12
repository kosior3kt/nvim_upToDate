vim.g.mapleader = " "
vim.keymap.set("n", "<leader>fv", vim.cmd.Ex, {desc = "open project tree"})

vim.keymap.set("n", "<leader>bn", ":bn<CR>", {desc = "next buffer"})
vim.keymap.set("n", "<leader>bp", ":bp<CR>", {desc = "previous buffer"})
vim.keymap.set("n", "<leader>bd", ":bd<CR>", {desc = "close buffer"})

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz", {desc = "Go to the next error"})
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz", {desc = "Go to the previous error"})
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz", {desc = "Go to next item from location list"})
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz", {desc = "Go to previous item from location list"})


vim.keymap.set("n", "<leader>:", ":<C-f>", {desc = "Open command menu"})

vim.keymap.set("n", "<leader>wh", "<C-w>h", {desc = "Go to the window left"})
vim.keymap.set("n", "<leader>wj", "<C-w>j", {desc = "Go to the window up"})
vim.keymap.set("n", "<leader>wk", "<C-w>k", {desc = "Go to the window down"})
vim.keymap.set("n", "<leader>wl", "<C-w>l", {desc = "Go to the window right"})
vim.keymap.set("n", "<leader>ws", "<C-w>s", {desc = "Open vertical window"})
vim.keymap.set("n", "<leader>wv", "<C-w>v", {desc = "Open horizontal window"})
vim.keymap.set("n", "<leader>wc", "<C-w>c", {desc = "Close window"})

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

vim.keymap.set("n", "'", "`") -- cmon, this shuold be the deafult behaviour...

local y = true
vim.keymap.set("n", "<leader>cc", function()
	if y then
		vim.opt.colorcolumn = "80"
		y = false
	else
		vim.opt.colorcolumn = ""
		y = true
	end
end, {desc = "toggle colorcolumn"})


-- this is ugly, but I dont give a fuck
vim.keymap.set("n", "<leader><leader>", function()
	local name = vim.fn.expand('%')
	if name == "/Users/jk/notes/quick_note.md" then
		vim.cmd[[:w]]
		vim.cmd[[:bd]]
	else
		vim.cmd[[:e /Users/jk/notes/quick_note.md]]
	end
end, {desc = "toggle the qnotes buffer"}
)

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
vim.keymap.set("n", "<leader>cw", function()
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



--- folding in c
function _G.c_style_fold(lnum)
    local line = vim.fn.getline(lnum) -- Get the current line text

    if line:match("^/%*") then
		if line:match("%*/$") then
			return "="	-- if this is one line comment ignore it
		else
			return "a1" -- else start of fold
		end
    elseif line:match("%*/$") then
		return "s1"	--end of fold
    else
		return "="  --maintain fold level
    end
end

-- Set foldmethod and foldexpr in Lua
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "c", "cpp" },
    callback = function()
        vim.opt_local.foldmethod = "expr"
        vim.opt_local.foldexpr = "v:lua._G.c_style_fold(v:lnum)"
		vim.cmd[[:highlight Folded guibg='#111111' guifg=DarkGreen ]]
		vim.cmd[[normal! zi]]
    end,
})

-- get to the last edit in file
vim.api.nvim_create_autocmd('BufReadPost', {
  desc = 'Open file at the last position it was edited earlier',
  group = misc_augroup,
  pattern = '*',
  command = 'silent! normal! g`"zv'
})


-- this one is for populating location list with my garbage
function _G.search_non_numbered_underscored_words()
    local bufnr = vim.api.nvim_get_current_buf() -- Get current buffer
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false) -- Get all lines
    local results = {}

    for lnum, line in ipairs(lines) do
        for match_start, match_end in line:gmatch("()__%w+__()") do
            local before = line:sub(1, match_start - 1)

            if not before:match("%d%)%s*$") then
                table.insert(results, {
                    bufnr = bufnr,
                    lnum = lnum,
                    col = match_start - 1, -- Column index (0-based)
                    text = line:sub(match_start, match_end - 1)
                })
            end
        end
    end

    if #results == 0 then
        print("No matches found!")
        return
    end

    vim.fn.setloclist(0, results, "r") -- Populate the location list
    vim.cmd("lopen") -- Open the location list
end

vim.keymap.set("n", "<leader>gO", _G.search_non_numbered_underscored_words, { noremap = true, silent = true })

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


vim.keymap.set("n", "<leader>n", "/jfge;laeghtaewghtgephtagwshtegaw<CR>", { desc="clears search results", silent = true })
