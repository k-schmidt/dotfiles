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
    end,
  },
}
