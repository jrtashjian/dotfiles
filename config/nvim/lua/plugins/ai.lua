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

            -- Handle `opencode` events
            vim.api.nvim_create_autocmd("User", {
              pattern = "OpencodeEvent:*", -- Optionally filter event types
              callback = function(args)
                local event = args.data.event

                -- if event.type == "permission.asked" then
                --     vim.notify(vim.inspect(event), vim.log.levels.INFO, { timeout = false, title = "Opencode" })
                --     vim.notify("`opencode` is asking for permission to execute code", vim.log.levels.WARN)
                -- end

                -- if event.type == "session.error" then
                --     vim.notify(vim.inspect(event), vim.log.levels.INFO, { timeout = false, title = "Opencode" })
                --     vim.notify("`opencode` session error: " .. event.data.error, vim.log.levels.ERROR)
                -- end

                if event.type == "question.asked" then
                    vim.notify(vim.inspect(event), vim.log.levels.INFO, { timeout = false, title = "Opencode" })
                    vim.notify("`opencode` is asking a question: ", vim.log.levels.INFO)
                end

                -- Notify when `opencode` finishes responding to an `ask()` or `select()` call
                if event.type == "session.idle" then
                    vim.notify("Finished responding", vim.log.levels.INFO, { title = "Opencode" })
                end

                if event.type == "server.connected" then
                    vim.notify("Connected to server", vim.log.levels.INFO, { title = "OpenCode" })
                end
              end,
            })
		end,
	},
}
