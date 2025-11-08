-- Bootstrap lazy.nvim
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

-- Appearance
-- transparent background
vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'none' })
vim.api.nvim_set_hl(0, 'Pmenu', { bg = 'none' })

-- Leaders
vim.g.mapleader = " "        -- Set space as leader key
vim.g.maplocalleader = "\\"  -- Set backslash as local leader

-- Navigation
vim.opt.whichwrap:append "<>[]hl"  -- Allow cursor to wrap at line ends

-- UI
vim.o.laststatus = 3          -- Global statusline
vim.o.showmode = false        -- Hide mode indicator
vim.o.splitkeep = "screen"    -- Keep screen position on splits
vim.o.clipboard = "unnamedplus" -- Use system clipboard
vim.o.cursorline = true       -- Highlight current line
vim.o.signcolumn = "yes"      -- Always show sign column
vim.o.splitbelow = true       -- New splits below
vim.o.splitright = true       -- New splits right
vim.o.wrap = false            -- Disable line wrapping

-- Indenting
vim.o.expandtab = true        -- Use spaces instead of tabs
vim.o.shiftwidth = 4          -- Indent width
vim.o.smartindent = true      -- Smart auto-indent
vim.o.tabstop = 4             -- Tab width
vim.o.softtabstop = 4         -- Soft tab width

-- Numbers
vim.o.number = true           -- Show line numbers
vim.o.numberwidth = 2         -- Minimum number column width
vim.o.ruler = false           -- Hide ruler

-- Search
vim.o.ignorecase = true       -- Case-insensitive search
vim.o.smartcase = true        -- Case-sensitive if uppercase used

-- Keymapping
local map = vim.keymap.set

map("n", "<C-h>", "<C-w>h", { desc = "switch window left" })
map("n", "<C-j>", "<C-w>j", { desc = "switch window down" })
map("n", "<C-k>", "<C-w>k", { desc = "switch window up" })
map("n", "<C-l>", "<C-w>l", { desc = "switch window right" })

map("n", "<Esc>", "<cmd>noh<CR>", { desc = "clear highlights" })

map("n", "<C-s>", "<cmd>w<CR>", { desc = "save file" })

map("n", "<leader>/", "gcc", { desc = "toggle comment", remap = true })
map("v", "<leader>/", "gc", { desc = "toggle comment", remap = true })

require("lazy").setup("plugins")
