-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<leader>zf", ":Telekasten find_notes<CR>", { desc = "[Z]ettel Find Notes" })
vim.keymap.set("n", "<leader>zg", ":Telekasten search_notes<CR>", { desc = "[Z]ettel Grep Notes" })
vim.keymap.set("n", "<leader>zn", ":Telekasten new_note<CR>", { desc = "[Z]ettel New Note" })
vim.keymap.set("n", "<leader>zb", ":Telekasten show_backlinks<CR>", { desc = "[Z]ettel Show Backlinks" })
vim.keymap.set("n", "<leader>zp", ":Telekasten panel<CR>", { desc = "[Z]ettel Panel" })

vim.keymap.set("n", "<leader>zi", function()
    local inbox_dir = vim.fn.expand("~/vaults/zettelkasten/inbox")

    if vim.fn.isdirectory(inbox_dir) == 0 then
        vim.fn.mkdir(inbox_dir, "p")
    end

    local filename = vim.fn.strftime("inbox_%Y-%m-%d_%H-%M-%S.md")
    local filepath = inbox_dir .. "/" .. filename

    vim.cmd("tabnew" .. filepath)

    vim.api.nvim_buf_set_lines(0, 0, -1, false, {
        "---",
        "date: " .. vim.fn.strftime("%Y-%m-%d %H:%M:%S"),
        "tags: [inbox, unprocessed]",
        "source: ",
        "---",
        "",
        "",
    })

    vim.api.nvim_win_set_cursor(0, { 4, 9 })
    vim.cmd("startinsert")
end, { desc = "[Z]ettel Quick [I]nbox Note" })
