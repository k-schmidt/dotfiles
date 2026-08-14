-- ~/.config/nvim/init.lua

-- 1. Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
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

-- 4. Basic Options (Keep your existing settings here)
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.clipboard = "unnamedplus"

-- 5. Mirror lazy-lock.json back into the chezmoi source dir
-- lazy rewrites the lockfile on any operation that moves plugin commits, but
-- only in the target tree, so pins silently drift from what is in git.
-- Note: lazy fires these events *before* it writes the lockfile (both are
-- callbacks on the same runner "done" emitter, event first), so the sync must
-- be deferred past the dispatch or it would capture the stale file.
vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("ChezmoiLockSync", {}),
  pattern = { "LazyInstall", "LazyUpdate", "LazyClean", "LazyRestore", "LazySync" },
  callback = function()
    if vim.fn.executable("chezmoi") == 0 then
      return
    end
    vim.schedule(function()
      local lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json"
      vim.system({ "chezmoi", "add", lockfile }, { text = true }, function(res)
        if res.code ~= 0 then
          vim.schedule(function()
            vim.notify("chezmoi add lazy-lock.json failed: " .. (res.stderr or ""), vim.log.levels.WARN)
          end)
        end
      end)
    end)
  end,
})
