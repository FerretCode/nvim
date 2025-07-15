return {
    { "ellisonleao/gruvbox.nvim" },
    { "romainl/Apprentice" },
    { "diegoulloao/neofusion.nvim" },
    { "catppuccin/nvim", name = "catppuccin" },
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = "apprentice",
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
