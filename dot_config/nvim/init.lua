-- ~/.config/nvim/init.lua

-- 1. Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- 2. Leader Key (Must be set BEFORE loading lazy)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- 3. Load Plugins from lua/plugins directory
require("lazy").setup("plugins")

-- 4. Apply the Colorscheme
vim.cmd.colorscheme "catppuccin"

-- 5. Basic Options (Keep your existing settings here)
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.clipboard = "unnamedplus"
