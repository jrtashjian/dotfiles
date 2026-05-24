return {
	{ "github/copilot.vim" },
	{
		"nickjvandyke/opencode.nvim",
		version = "*", -- Latest stable release
		dependencies = {
			{
				-- `snacks.nvim` integration is recommended, but optional
				---@module "snacks" <- Loads `snacks.nvim` types for configuration intellisense
				"folke/snacks.nvim",
				optional = true,
				opts = {
					input = {}, -- Enhances `ask()`
					picker = { -- Enhances `select()`
						actions = {
							opencode_send = function(...)
								return require("opencode").snacks_picker_send(...)
							end,
						},
						win = {
							input = {
								keys = {
									["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
								},
							},
						},
					},
				},
			},
		},
		config = function()
			vim.g.opencode_opts = {}

			vim.o.autoread = true -- Required for `opts.events.reload`

            -- stylua: ignore start
			vim.keymap.set({ "n", "x" }, "<leader>oa", function() require("opencode").ask("@this: ", { submit = true }) end, { desc = "Ask opencode…" })
			vim.keymap.set({ "n", "x" }, "<leader>ox", function() require("opencode").select() end, { desc = "Select opencode…" })

			vim.keymap.set({ "n", "x" }, "go", function() return require("opencode").operator("@this ") end, { desc = "Add range to opencode", expr = true })
			vim.keymap.set("n", "goo", function() return require("opencode").operator("@this ") .. "_" end, { desc = "Add line to opencode", expr = true })
		end,
	},
}
