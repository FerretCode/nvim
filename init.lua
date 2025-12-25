-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.o.tabstop = 4
vim.o.expandtab = true
vim.o.softtabstop = 4
vim.o.shiftwidth = 4

-- for block, = "a:block"
vim.o.guicursor = table.concat({
    "n-v-c:block", -- normal, visual, command-line -> block
    "i:ver25", -- insert -> vertical beam at 25% width
    "r-cr:hor20", -- replace modes -> horizontal bar
    "o:hor50", -- operator-pending -> thicker bar
}, ",")
vim.o.mouse = "a"

vim.api.nvim_set_option("clipboard", "unnamed")

require("conform").setup({
    formatters_by_ft = {
        lua = { "stylua" },
        html = { "prettier" },
    },
    formatters = {
        stylua = {
            prepend_args = { "--indent-type", "Spaces", "--indent-width", "4" },
        },
        prettier = {
            prepend_args = { "--tab-width", "4" },
        },
    },
})

require("lspconfig").clangd.setup({
    cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--header-insertion=iwyu",
        "--completion-style=detailed",
        "--function-arg-placeholders=true",
        "--compile-commands-dir=build",
    },
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "ino", "arduino" },
})

require("lspconfig").gopls.setup({
    settings = {
        gopls = {
            format = {
                tabWidth = 4,
            },
        },
    },
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

require("mason").setup({
    registries = {
        "github:mason-org/mason-registry",
        "github:Crashdummyy/mason-registry",
    },
})

require("roslyn").setup({
    choose_target = function(targets)
        local sln_target = vim.iter(targets):find(function(item)
            return string.match(item, ".sln$")
        end)

        if sln_target then
            return sln_target
        end
    end,
})

require("conform").setup({
    format_on_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
        end
        return { timeout_ms = 500, lsp_format = "fallback" }
    end,
})

require("telekasten").setup({
    home = vim.fn.expand("~/vaults/zettelkasten"),
})

vim.api.nvim_create_user_command("FormatDisable", function(args)
    if args.bang then
        vim.b.disable_autoformat = true
    else
        vim.g.disable_autoformat = true
    end
end, {
    desc = "Disable autoformat-on-save",
    bang = true,
})

vim.api.nvim_create_user_command("FormatEnable", function()
    vim.b.disable_autoformat = false
    vim.g.disable_autoformat = false
end, {
    desc = "Re-enable autoformat-on-save",
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "*.ino",
    callback = function()
        vim.bo.filetype = "cpp"
    end,
})
