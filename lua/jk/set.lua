vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
-- vim.opt.smartindent = true

vim.g.rust_recommended_style = 0
vim.g.java_recommended_style = 0
vim.g.cpp_recommended_style = 0
vim.g.c_recommended_style = 0

vim.opt.wrap = false
vim.opt.mouse = ""

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

vim.opt.conceallevel = 1

-- some deranged shit to make this shit usable

vim.g.python3_host_prog = '/opt/homebrew/bin/python3'

local cpp_macos_includes = "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/c++/v1"
local cpp_macos_local_includes = "/usr/local/include"
local idk_at_this_point = "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX14.2.sdk/usr/include"
local cpp_macos_sdl2_includes = "/opt/homebrew/include/SDL2"
local stm32_headers = "/Users/jk/vendor/stm32/"


vim.opt.path = {'.', '**', '/usr/include'}
vim.opt.path:prepend(cpp_macos_local_includes)
vim.opt.path:prepend(cpp_macos_includes)
vim.opt.path:prepend(cpp_macos_sdl2_includes)
vim.opt.path:prepend(idk_at_this_point)




