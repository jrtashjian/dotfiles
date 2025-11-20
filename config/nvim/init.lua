-- -----------------------------------------------------------------------------------------------
-- General configuration
-- -----------------------------------------------------------------------------------------------
-- Leaders
vim.g.mapleader = " " -- Set space as leader key
vim.g.maplocalleader = "\\" -- Set backslash as local leader

-- Navigation
vim.opt.whichwrap:append("<>[]hl") -- Allow cursor to wrap at line ends
vim.opt.sidescrolloff = 8
vim.opt.scrolloff = 8

-- UI
vim.o.laststatus = 3 -- Global statusline
vim.o.showmode = false -- Hide mode indicator
vim.o.splitkeep = "screen" -- Keep screen position on splits
vim.o.clipboard = "unnamedplus" -- Use system clipboard
vim.o.cursorline = true -- Highlight current line
vim.o.signcolumn = "yes" -- Always show sign column
vim.o.splitbelow = true -- New splits below
vim.o.splitright = true -- New splits right
vim.o.wrap = false -- Disable line wrapping

-- Indenting
vim.o.expandtab = true -- Use spaces instead of tabs
vim.o.shiftwidth = 4 -- Indent width
vim.o.smartindent = true -- Smart auto-indent
vim.o.tabstop = 4 -- Tab width
vim.o.softtabstop = 4 -- Soft tab width

-- Numbers
vim.o.number = true -- Show line numbers
vim.o.numberwidth = 2 -- Minimum number column width
vim.o.ruler = false -- Hide ruler

-- Search
vim.o.ignorecase = true -- Case-insensitive search
vim.o.smartcase = true -- Case-sensitive if uppercase used

require("autocmds")
require("mappings")

-- -----------------------------------------------------------------------------------------------
-- Plugin installation
-- -----------------------------------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	spec = { import = "plugins" },
	checker = { enabled = true },
})
