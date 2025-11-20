return {
	"nvim-treesitter/nvim-treesitter",
	branch = "master",
	lazy = false,
	build = ":TSUpdate",
	opts = {
		auto_install = true,
		hightlight = { enable = true },
		indent = { enable = true },
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
	},
	init = function()
		vim.wo.foldmethod = "expr"
		vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
		vim.opt.foldlevel = 99
	end,
}
