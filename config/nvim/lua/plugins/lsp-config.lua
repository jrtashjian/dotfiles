return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "stylua" },
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			vim.diagnostic.config({ virtual_text = true })
		end,
	},
	{
		"nvimtools/none-ls.nvim",
		config = function()
			local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

			require("null-ls").setup({
				sources = { require("null-ls").builtins.formatting.stylua },
				-- format document on save using only null-ns.
				on_attach = function(client, bufnr)
					if client.supports_method("textDocument/formatting") then
						vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
						vim.api.nvim_create_autocmd("BufWritePre", {
							group = augroup,
							buffer = bufnr,
							callback = function()
								vim.lsp.buf.format({
									async = false,
									bufnr = bufnr,
									filter = function(formatter)
										return formatter.name == "null-ls"
									end,
								})
							end,
						})
					end
				end,
			})
			-- manually format buffer content.
			vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
		end,
	},
}
