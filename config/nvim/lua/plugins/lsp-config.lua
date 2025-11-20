-- LSP and formatting configuration
return {
	{
		"williamboman/mason.nvim",
		opts = {},
	},
    -- LSP server configuration
	{
		"williamboman/mason-lspconfig.nvim",
		opts = {
			ensure_installed = {
				"lua_ls",
				"intelephense",
				"eslint",
				"bashls",
				"html",
				"jsonls",
				"sqlls",
				"terraformls",
				"yamlls",
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		opts = {},
		config = function()
			vim.lsp.inlay_hint.enable(true)

			vim.diagnostic.config({
				virtual_lines = true,
				severity_sort = true,
			})
		end,
	},
    -- Code formatter configuration
	{
		"stevearc/conform.nvim",
		opts = {
            default_format_opts = {
                lsp_format = "fallback"
            },
			formatters_by_ft = {
                lua = { "stylua" },
                php = { "phpcbf", "php-cs-fixer", "pint", stop_after_first = true },
			},
		},
		keys = {
			{ "<leader>gf", ":lua require('conform').format()<CR>", desc = "Format file" },
		},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		config = function()
			require("mason-tool-installer").setup({
				ensure_installed = {
					-- lua
					"stylua",
					-- php
					"phpcs",
					"phpcbf",
					"php-cs-fixer",
					"pint",
				},
			})
		end,
	},
}
