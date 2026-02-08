-- ~/.config/nvim/init.lua

-- Set <space> as the leader key
vim.g.mapleader = " "

-- Basic Options
vim.opt.number = true             -- Show line numbers
vim.opt.relativenumber = true     -- Relative line numbers
vim.opt.clipboard = "unnamedplus" -- Sync with system clipboard
vim.opt.ignorecase = true         -- Case insensitive searching
vim.opt.smartcase = true          -- Case sensitive if uppercase present

-- Example Keymap (Save with <leader>w)
vim.keymap.set("n", "<leader>w", ":w<CR>")
