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
              pattern = "OpencodeEvent:*",
              callback = function(args)
                local event = args.data.event

                local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }

                -- -- Log all events for debugging 
                -- vim.notify(vim.inspect(event), vim.log.levels.INFO, { title = "OpenCode", timeout = 1 })

                if event.type == "session.status" then
                    -- event = {
                    --   properties = {
                    --     status = { type = "busy" }
                    --   },
                    --   type = "session.status"
                    -- }
                    --
                    -- event = {
                    --   properties = {
                    --     status = { type = "idle" }
                    --   },
                    --   type = "session.status"
                    -- }
                    local status = event.properties.status.type

                    local status_message = ({
                        busy = "Thinking...",
                        idle = "All done!",
                    })[status] or (status)

                    vim.notify(status_message, vim.log.levels.INFO, {
                        id = "opencode_status",
                        timeout = status == "idle" and 3000 or false, -- Keep busy status until it changes, auto-dismiss idle status
                        title = "OpenCode",
                        opts = function(notif)
                            local idx = math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1
                            notif.icon = status == "busy" and spinner[idx] .. " " or ""
                        end,
                    })
                end

                -- if event.type == "question.asked" then
                --     -- event = {
                --     --   properties = {
                --     --     questions = { {
                --     --         header = "Commit message",
                --     --         options = { {
                --     --             description = "Add autocmds for opencode events like question.asked, session.idle, and server.connected",
                --     --             label = "Add opencode event notifications"
                --     --           }, {
                --     --             description = "I'll provide my own commit message",
                --     --             label = "Let me write a custom message"
                --     --           } },
                --     --         question = "What commit message would you like to use?"
                --     --       } },
                --     --   },
                --     --   type = "question.asked"
                --     -- }
                --     vim.notify(event.properties.questions[1].header, vim.log.levels.INFO, { title = "OpenCode" })
                -- end

                if event.type == "server.connected" then
                    -- event = {
                    --   properties = vim.empty_dict(),
                    --   type = "server.connected"
                    -- }
                    vim.notify("Connected", vim.log.levels.INFO, { id="opencode_connection", title = "OpenCode" })
                end

                if event.type == "server.instance.disposed" then
                    -- event = {
                    --   properties = { directory = "/current/working/directory" },
                    --   type = "server.instance.disposed"
                    -- }
                    vim.notify("Disconnected", vim.log.levels.WARN, { id="opencode_connection", title = "OpenCode", timeout = false })
                end

              end,
            })
		end,
	},
}
