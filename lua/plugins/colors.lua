return {
    { "ellisonleao/gruvbox.nvim" },
    { "romainl/Apprentice" },
    { "diegoulloao/neofusion.nvim" },
    { "catppuccin/nvim", name = "catppuccin" },
    { "AlphaTechnolog/pywal.nvim", name = "pywal" },
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = "pywal",
        },
    },
    {
        "goolord/alpha-nvim",
        event = "VimEnter",
        opts = {},
        config = function()
            local alpha = require("alpha")
            local dashboard = require("alpha.themes.dashboard")

            dashboard.section.header.val = {
                [[███    ██ ███████  ██████  ██    ██ ██ ███    ███]],
                [[████   ██ ██      ██    ██ ██    ██ ██ ████  ████]],
                [[██ ██  ██ █████   ██    ██ ██    ██ ██ ██ ████ ██]],
                [[██  ██ ██ ██      ██    ██  ██  ██  ██ ██  ██  ██]],
                [[██   ████ ███████  ██████    ████   ██ ██      ██]],
            }

            --[[
            dashboard.section.buttons.val = {
                dashboard.button("")
            }]]
            --

            alpha.setup(dashboard.config)
        end,
    },
}
