-- Description: UI/UX related plugins and configurations
return {
	-- Dracula color scheme
	{
		"Mofiqul/dracula.nvim",
		init = function()
			vim.cmd.colorscheme("dracula")
		end,
	},
	-- Lualine status line
	{
		"nvim-lualine/lualine.nvim",
		opts = {
			options = {
				theme = "dracula",
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diagnostics" },
				lualine_c = { { "filename", path = 1 } },
				lualine_x = {},
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
		},
	},
	-- Snacks.nvim for various UI enhancements
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			dashboard = { enabled = true },
			explorer = { enabled = true },
			indent = { enabled = true },
			input = { enabled = true },
			notifier = { enabled = true },
			scratch = { enabled = true },
			terminal = { enabled = true },
			picker = {
				previewers = {
					-- Use terminal style previewer for diffs
					diff = {
						style = "terminal",
					},
				},
				win = {
					-- Close picker with Esc in normal and insert modes
					input = {
						keys = {
							["<Esc>"] = { "close", mode = { "n", "i" } },
						},
					},
				},
			},
		},
        -- stylua: ignore start
        keys = {
            -- Top Pickers & Explorer
            { "<leader><space>", function() Snacks.picker.smart() end,                desc = "Smart Find Files" },
            { "<leader>,",       function() Snacks.picker.buffers() end,              desc = "Buffers" },
            { "<leader>/",       function() Snacks.picker.grep() end,                 desc = "Grep" },
            { "<leader>:",       function() Snacks.picker.command_history() end,      desc = "Command History" },
            { "<leader>e",       function() Snacks.explorer() end,                    desc = "File Explorer" },

            -- find
            { "<leader>ff",      function() Snacks.picker.files() end,                desc = "Find Files" },
            { "<leader>fp",      function() Snacks.picker.projects() end,             desc = "Projects" },
            { "<leader>fr",      function() Snacks.picker.recent() end,               desc = "Recent" },

            -- git
            { "<leader>gb",      function() Snacks.picker.git_branches() end,         desc = "Git Branches" },
            { "<leader>gl",      function() Snacks.picker.git_log() end,              desc = "Git Log" },
            { "<leader>gs",      function() Snacks.picker.git_status() end,           desc = "Git Status" },
            { "<leader>gB",      function() Snacks.gitbrowse() end,                   desc = "Git Browse",                 mode = { "n", "v" } },

            -- gh
            { "<leader>gi",      function() Snacks.picker.gh_issue() end,             desc = "GitHub Issues (open)" },
            { "<leader>gp",      function() Snacks.picker.gh_pr() end,                desc = "GitHub Pull Requests (open)" },

            -- search
            { "<leader>sd",      function() Snacks.picker.diagnostics() end,          desc = "Diagnostics" },
            { "<leader>sh",      function() Snacks.picker.help() end,                 desc = "Help Pages" },

            -- LSP
            { "gd",              function() Snacks.picker.lsp_definitions() end,      desc = "Goto Definition" },
            { "gD",              function() Snacks.picker.lsp_declarations() end,     desc = "Goto Declaration" },
            { "gI",              function() Snacks.picker.lsp_implementations() end,  desc = "Goto Implementation" },
            { "gy",              function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
            { "gr",              function() Snacks.picker.lsp_references() end,       nowait = true,                       desc = "References" },
            { "<leader>ss",      function() Snacks.picker.lsp_symbols() end,          desc = "LSP Symbols" },
        },
		-- stylua: ignore end
	},
	-- Gitsigns with current line blame
	{
		"lewis6991/gitsigns.nvim",
		opts = { current_line_blame = true },
	},
}
