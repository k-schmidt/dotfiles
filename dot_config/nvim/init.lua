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

-- 2. Volta shims on PATH
-- On the work devserver /usr/local/bin/npm is a stub that refuses every
-- install ("use mgt cli"), so Mason's npm-backed servers fail unless Volta's
-- shims resolve first. nvim inherits PATH from whatever launched it, which is
-- not always a shell that sourced zshrc, so pin it here as well. Only
-- prepended when absent, which keeps the shell's own ordering (Homebrew >
-- Volta > system) intact whenever it already set things up.
local volta_bin = vim.env.HOME .. "/.volta/bin"
if vim.uv.fs_stat(volta_bin) and not string.find(vim.env.PATH, volta_bin, 1, true) then
  vim.env.PATH = volta_bin .. ":" .. vim.env.PATH
end

-- 3. Leader Key (Must be set BEFORE loading lazy)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- 4. Load Plugins from lua/plugins directory
require("lazy").setup("plugins")

-- 5. Basic Options (Keep your existing settings here)
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.clipboard = "unnamedplus"

-- Clipboard provider on a headless box.
-- With no X display "unnamedplus" has nothing to write to. Neovim does fall
-- back to OSC 52, but only when $SSH_TTY is set -- and tmux's default
-- update-environment list omits SSH_TTY, so inside a pane the detection misses
-- and every yank silently goes nowhere. Pin the provider instead of relying on
-- it. tmux forwards the escape onward via `set -g set-clipboard on`.
-- macOS is left alone: it has a real pbcopy provider.
if
  vim.uv.os_uname().sysname == "Linux"
  and not vim.env.DISPLAY
  and not vim.env.WAYLAND_DISPLAY
then
  local osc52 = require("vim.ui.clipboard.osc52")
  -- Read back from the unnamed register rather than querying the terminal.
  -- An OSC 52 paste blocks waiting for a reply that most terminals refuse to
  -- send by default, which would hang `p` instead of just pasting the yank.
  local function paste()
    return { vim.split(vim.fn.getreg(""), "\n"), vim.fn.getregtype("") }
  end
  vim.g.clipboard = {
    name = "OSC 52",
    copy = { ["+"] = osc52.copy("+"), ["*"] = osc52.copy("*") },
    paste = { ["+"] = paste, ["*"] = paste },
  }
end

-- 6. Mirror lazy-lock.json back into the chezmoi source dir
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
            vim.notify(
              "chezmoi add lazy-lock.json failed: " .. (res.stderr or ""),
              vim.log.levels.WARN
            )
          end)
        end
      end)
    end)
  end,
})
