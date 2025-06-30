-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.o.tabstop = 4
vim.o.expandtab = true
vim.o.softtabstop = 4
vim.o.shiftwidth = 4

-- vim.o.guicursor = "a:block"

require("conform").setup({
    formatters_by_ft = {
        lua = { "stylua" },
    },
    formatters = {
        stylua = {
            prepend_args = { "--indent-type", "Spaces", "--indent-width", "4" },
        },
        prettier = {
            args = function(ctx)
                return { "--tab-width", "4", "--parser", "babel", ctx.filename }
            end,
        },
    },
})

require("lspconfig").gopls.setup({
    settings = {
        gopls = {
            format = {
                tabWidht = 4,
            },
        },
    },
})

require("lspconfig").clangd.setup({
    cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--header-insertion=never",
        "--completion-style=detailed",
        "--pch-storage=memory",
        "--header-insertion-decorators=false",
        "--log=verbose",
        "--query-driver=/usr/bin/arm-none-eabi-g*",
        "--fallback-style=webkit",
    },
    filetypes = { "c", "cpp", "objc", "obcjpp" },
    root_dir = function(fname)
        return require("lspconfig").util.root_pattern("compile_commands.json", ".git")(fname)
    end,
})

require("lspconfig").lua_ls.setup({
    settings = {
        Lua = {
            runtime = {
                version = "Lua 5.4",
                path = vim.split(package.path, ";"),
            },
            workspace = {
                library = {
                    vim.fn.expand("$VIMRUNTIME/lua"),
                    vim.fn.expand(".luaenv/share/lua/5.4"),
                    vim.fn.expand(".luaenv/lib/luarocks/rocks-5.4"),
                },
                checkThirdParty = false,
            },
            diagnostics = {
                globals = { "vim" },
            },
        },
    },
})
