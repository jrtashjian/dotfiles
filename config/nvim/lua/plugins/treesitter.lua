local languages = {
	"lua",
	"vim",
	"vimdoc",
	"python",
	"javascript",
	"typescript",
	"sql",
	"bash",
	"css",
	"diff",
	"dockerfile",
	"html",
	"json",
	"markdown",
	"markdown_inline",
	"terraform",
	"yaml",
	"php",
}

local function enable_treesitter(buf)
	local filetype = vim.bo[buf].filetype
	if filetype == "" then
		return
	end

	local lang = vim.treesitter.language.get_lang(filetype)
	if not lang or not vim.treesitter.language.add(lang) then
		return
	end

	if not vim.b[buf].ts_highlight then
		vim.treesitter.start(buf, lang)
	end

	-- indentexpr is evaluated as Vimscript, so the require stays in a string.
	vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

	for _, win in ipairs(vim.fn.win_findbuf(buf)) do
		vim.api.nvim_win_call(win, function()
			vim.wo[0][0].foldmethod = "expr"
			vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
			vim.wo[0][0].foldlevel = 99
		end)
	end
end

local function enable_open_buffers()
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(buf) then
			enable_treesitter(buf)
		end
	end
end

local function tree_sitter_cli_ok()
	if vim.fn.executable("tree-sitter") == 0 then
		vim.notify("tree-sitter CLI not found; parser install skipped", vim.log.levels.ERROR)
		return false
	end

	local version = vim.version.parse(vim.fn.system({ "tree-sitter", "--version" }))
	if not version or not vim.version.ge(version, { 0, 26, 1 }) then
		vim.notify("tree-sitter CLI 0.26.1 or later is required; parser install skipped", vim.log.levels.ERROR)
		return false
	end

	return true
end

return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter").setup({
			install_dir = vim.fn.stdpath("data") .. "/site",
		})

		vim.api.nvim_create_autocmd({ "FileType", "BufWinEnter" }, {
			group = vim.api.nvim_create_augroup("treesitter_features", { clear = true }),
			callback = function(event)
				enable_treesitter(event.buf)
			end,
		})

		enable_open_buffers()

		if not tree_sitter_cli_ok() then
			return
		end

		-- install() is async. Re-enable so the buffer opened at startup is not
		-- left without a parser that finishes downloading after FileType.
		require("nvim-treesitter").install(languages):await(function()
			vim.schedule(enable_open_buffers)
		end)
	end,
}
