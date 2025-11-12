return {
    "Mofiqul/dracula.nvim",
    config = function()
        local config = require("dracula")
        config.setup({
            transparent_bg = true,
        })

        vim.cmd([[colorscheme dracula]])
    end,
}
