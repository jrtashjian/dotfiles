return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		dashboard = { enabled = true },
		explorer = { enabled = true },
		indent = { enabled = true },
		input = { enabled = true },
		picker = { enabled = true },
		notifier = { enabled = true },
		scratch = { enabled = true },
		terminal = { enabled = true },
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

        -- Scratch
        { "<leader>.",       function() Snacks.scratch() end,                     desc = "Toggle Scratch Buffer" },
        { "<leader>S",       function() Snacks.scratch.select() end,              desc = "Select Scratch Buffer" },

        { "<c-/>",           function() Snacks.terminal() end,                    desc = "Toggle Terminal" },
    },
	-- stylua: ignore end
}
