-- Single source of truth: mason installs these, mason-lspconfig enables them.
local servers = {
  "pyright",
  "ts_ls",
  "lua_ls",
  -- gopls omitted: mason builds it with `go install` and there is no Go
  -- toolchain here. Add brew "go" to the Brewfile before re-adding it.
  "rust_analyzer",
  "bashls",
  "dockerls",
  "docker_compose_language_service",
  "yamlls",
  "jsonls",
  "sqlls",
}

return {
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    opts = {},
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = servers,
      -- automatic_enable defaults to true: calls vim.lsp.enable() for each
      -- installed server, so no explicit enable list is needed.
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- LSP keybindings on attach
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local opts = { buffer = ev.buf }
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set("n", "<leader>ds", "<cmd>Telescope lsp_document_symbols<cr>", opts)
        end,
      })

      -- Global capabilities for all servers
      vim.lsp.config("*", {
        capabilities = capabilities,
      })

      -- lua_ls: recognize vim global
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
          },
        },
      })
    end,
  },
}
