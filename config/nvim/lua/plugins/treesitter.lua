return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter").setup({
			-- Directory to install parsers and queries to
			install_dir = vim.fn.stdpath("data") .. "/site",
			ensure_installed = {
				"lua",
				"vim",
				"vimdoc",
				"python",
				"javascript",
				"typescript",
				"sql",
				"bash",
				"css",
				"diff",
				"dockerfile",
				"html",
				"json",
				"markdown",
				"terraform",
				"yaml",
				"php",
			},
			auto_install = true,
			highlight = { enable = true },
			indent = { enable = true },
		})

		vim.wo.foldmethod = "expr"
		vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
		vim.opt.foldlevel = 99
	end,
}
