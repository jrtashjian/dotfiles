-- LSP and formatting configuration
local lsp_servers = {
	"lua_ls",
	"intelephense",
	"eslint",
	"bashls",
	"html",
	"jsonls",
	"sqlls",
	"terraformls",
	"yamlls",
}

return {
	{
		"williamboman/mason.nvim",
		opts = {},
	},
    -- LSP server configuration
	{
		"williamboman/mason-lspconfig.nvim",
		opts = {
			ensure_installed = lsp_servers,
		},
	},
	{
		"neovim/nvim-lspconfig",
		opts = function()
            -- Dynamically create server configurations from the lsp_servers list
			local servers = {}
			for _, server in ipairs(lsp_servers) do
				servers[server] = {}
			end

			return { servers = servers }
		end,
		config = function(_, opts)
			vim.lsp.inlay_hint.enable(true)

			vim.diagnostic.config({
				virtual_lines = true,
				severity_sort = true,
			})

			for server, config in pairs(opts.servers) do
				config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
				vim.lsp.config(server, config)
				vim.lsp.enable(server)
			end
		end,
	},
    -- Code formatter configuration
	{
		"stevearc/conform.nvim",
		opts = {
            default_format_opts = { lsp_format = "fallback" },
			formatters_by_ft = {
                lua = { "stylua" },
                php = { "phpcbf", "php_cs_fixer", "pint", stop_after_first = true },
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
    -- Completion capabilities for LSP
    {
        "saghen/blink.cmp",
        version = "1.*",
        opts = {},
    },
}
