return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
	},
    lazy = false,
	config = function()
		vim.keymap.set("n", "<C-n>", ":Neotree filesystem toggle<CR>", { desc = "toggle file explorer" })
		vim.keymap.set("n", "<leader>e", ":Neotree filesystem focus<CR>", { desc = "focus file explorer" })
		vim.keymap.set("n", "<leader>bf", ":Neotree buffers reveal float<CR>", { desc = "show open editors" })

        require("neo-tree").setup({
            window = {
                position = "right",
            },
            filesystem = {
                filtered_items = {
                    hide_gitignored = false,
                    always_show = {
                        ".gitignore",
                    },
                    always_show_by_pattern = {
                        ".env*"
                    },
                },
            },
        })
	end,
}
