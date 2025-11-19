return {
	{ "github/copilot.vim" },
	{
		"NickvanDyke/opencode.nvim",
		dependencies = {
			---@module 'snacks'
			{ "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
		},
		config = function()
			vim.g.opencode_opts = {}

			vim.o.autoread = true

            -- stylua: ignore start
            vim.keymap.set({ "n", "x" }, "<leader>oa",
                function() require("opencode").ask("@this: ", { submit = true }) end,
                { desc = "Ask opencode" })
            vim.keymap.set({ "n", "x" }, "<leader>ox", function() require("opencode").select() end,
                { desc = "Execute opencode action…" })
            vim.keymap.set({ "n", "x" }, "<leader>og", function() require("opencode").prompt("@this") end,
                { desc = "Add to opencode" })
            vim.keymap.set({ "n", "t" }, "<leader>ot", function() require("opencode").toggle() end,
                { desc = "Toggle opencode" })
			-- stylua: ignore end
		end,
	},
}
