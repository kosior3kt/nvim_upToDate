vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50


vim.wo.wrap = false

vim.opt.cursorline = true
vim.opt.cursorcolumn = true

-- some deranged shit to make this shit usable

vim.g.python3_host_prog = '/opt/homebrew/bin/python3'

local cpp_macos_includes = "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/c++/v1"
vim.opt.path = {'.', '**', '/usr/include'}
vim.opt.path:append(cpp_macos_includes)
