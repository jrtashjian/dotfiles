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
		"mason-org/mason.nvim",
		opts = {},
	},
	-- LSP server configuration
	{
		"mason-org/mason-lspconfig.nvim",
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

            servers.intelephense = {
                settings = {
                    intelephense = {
                        stubs = {
                            -- Core PHP stubs
                            "bcmath", "bz2", "calendar", "Core", "curl", "date", "dom", "fileinfo",
                            "filter", "gd", "gettext", "hash", "iconv", "intl", "json", "libxml",
                            "mbstring", "mysqli", "mysqlnd", "openssl", "pcre", "PDO", "pdo_mysql",
                            "phar", "posix", "readline", "Reflection", "session", "SimpleXML",
                            "soap", "sockets", "sodium", "SPL", "sqlite3", "standard", "superglobals", "tokenizer",
                            "xml", "xmlreader", "xmlwriter", "zip", "zlib",

                            -- WordPress
                            "wordpress" }
                    }
                }
            }

			return { servers = servers }
		end,
		config = function(_, opts)
			vim.lsp.inlay_hint.enable(true)

			vim.diagnostic.config({
				virtual_lines = true,
				severity_sort = true,
			})

			for server, config in pairs(opts.servers) do
				config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
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
			{ "<leader>gf", function() require("conform").format() end, desc = "Format file" },
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
