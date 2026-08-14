return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("nvim-treesitter").setup()

      -- Install parsers for target languages
      local ensure_installed = {
        "python",
        "typescript",
        "javascript",
        "tsx",
        "lua",
        "go",
        "rust",
        "bash",
        "dockerfile",
        "yaml",
        "json",
        "sql",
        "markdown",
        "vim",
        "vimdoc",
      }

      local installed = require("nvim-treesitter").get_installed()
      local to_install = vim.tbl_filter(function(lang)
        return not vim.list_contains(installed, lang)
      end, ensure_installed)

      if #to_install > 0 then
        require("nvim-treesitter").install(to_install)
      end

      -- nvim-treesitter (main) does not enable highlighting itself, and Neovim
      -- only auto-starts it for its own bundled parsers. Start it per buffer;
      -- pcall covers filetypes with no installed parser.
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("UserTreesitterStart", {}),
        callback = function(ev)
          pcall(vim.treesitter.start, ev.buf)
        end,
      })
    end,
  },
}
