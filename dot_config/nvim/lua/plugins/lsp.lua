-- Single source of truth: mason installs these, mason-lspconfig enables them.
local servers = {
  -- Python: pyrefly types, ruff lint/format. Both supersede pyright.
  "pyrefly",
  "ruff",
  -- Web: tsgo is the native TypeScript server, superseding ts_ls.
  "tsgo",
  "eslint",
  "tailwindcss",
  "lua_ls",
  "rust_analyzer",
  "bashls",
  "dockerls",
  "docker_compose_language_service",
  "yamlls",
  "jsonls",
  -- SQL: postgres_lsp for Postgres dialect, sqruff for lint/format.
  -- sqlls omitted: sql-language-server v1.7.1 is unmaintained and crashes on
  -- startup under any modern Node with ERR_PACKAGE_PATH_NOT_EXPORTED (it
  -- reaches into a vscode-languageserver-protocol subpath that "exports" now
  -- blocks). Its sqlite3 dep also needs a native build the proxy can't fetch.
  "postgres_lsp",
  "sqruff",
}

-- gopls is the one server mason builds with `go install`, so ask for it only
-- where a Go toolchain exists. Without this guard a machine lacking Go retries
-- a failing build on every startup instead of quietly going without.
if vim.fn.executable("go") == 1 then
  table.insert(servers, "gopls")
end

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
      "saghen/blink.cmp",
    },
    config = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities()

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
