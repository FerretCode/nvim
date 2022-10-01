require('plugins')
 
-- vim options
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.termguicolors = true
vim.opt.guifont = "JetBrainsMono Nerd Font"
vim.api.nvim_set_hl(0, "StatusLineNC", { fg = "#FFFFFF", bg = "NONE" })
vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1
vim.g.rust_recommended_style = false

-- colorscheme
vim.cmd("colorscheme catppuccin")
--vim.cmd("highlight Normal ctermbg=NONE guibg=NONE")

-- nvim tree keybinds
local keymap = vim.api.nvim_set_keymap
local default_opts = { noremap = true, silent = true }
local expr_opts = { noremap = true, expr = true, silent = true }

keymap("n", "<S-n>", ":NvimTreeToggle<CR>", default_opts)
keymap("n", "<S-Left>", ":bprevious<CR>", default_opts)
keymap("n", "<S-Right>", ":bnext<CR>", default_opts)
keymap("n", "<S-y>", ":TroubleToggle<CR>", default_opts)
keymap("n", "<C-f>", ":Telescope find_files<CR>", default_opts)
keymap("n", "<C-x>", ":Telescope find_files cwd=..<CR>", default_opts)

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = true,
    virtual_text = false,
    signs = false,
    update_in_insert = false,
  }
)

--nvim tree
require("nvim-tree").setup()
