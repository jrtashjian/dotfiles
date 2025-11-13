return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
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
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					-- lua
					"lua_ls",
					-- php
					"phpactor",
					"laravel_ls",
				},
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

			local sources = {
				require("null-ls").builtins.formatting.stylua,
			}

			-- is_laravel
			if vim.fn.filereadable("artisan") == 1 then
				table.insert(sources, require("null-ls").builtins.formatting.pint)
				table.insert(sources, require("null-ls").builtins.diagnostics.php_cs_fixer)
			else
				table.insert(sources, require("null-ls").builtins.formatting.phpcbf)
				table.insert(sources, require("null-ls").builtins.diagnostics.phpcs)
			end

			require("null-ls").setup({
				sources = sources,
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
