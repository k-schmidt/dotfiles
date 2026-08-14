return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo", "FormatDisable", "FormatEnable" },
    keys = {
      -- <leader>cf, not <leader>f: a bare <leader>f would make every
      -- <leader>ff / <leader>fg / <leader>fb wait out timeoutlen first.
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        mode = { "n", "v" },
        desc = "Format buffer",
      },
    },
    -- opts is a function, not a table: the ruff override below requires
    -- conform.util, which is not on the runtimepath while specs are evaluated.
    opts = function()
      -- conform ships ruff as a bare `command = "ruff"` PATH lookup, which
      -- misses uv's per-project venv unless it happens to be activated.
      -- Search upward for .venv/bin/ruff first so the project's pinned ruff
      -- wins over anything global.
      local ruff =
        require("conform.util").find_executable({ ".venv/bin/ruff", "venv/bin/ruff" }, "ruff")

      return {
        formatters = {
          ruff_format = { command = ruff },
          ruff_organize_imports = { command = ruff },
        },
        formatters_by_ft = {
          -- prettier resolves from node_modules/.bin automatically.
          python = { "ruff_organize_imports", "ruff_format" },
          lua = { "stylua" },
          sh = { "shfmt" },
          bash = { "shfmt" },
          typescript = { "prettier" },
          typescriptreact = { "prettier" },
          javascript = { "prettier" },
          javascriptreact = { "prettier" },
          json = { "prettier" },
          yaml = { "prettier" },
          markdown = { "prettier" },
        },
        default_format_opts = { lsp_format = "fallback" },
        format_on_save = function(bufnr)
          if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
          end
          return { timeout_ms = 1000, lsp_format = "fallback" }
        end,
      }
    end,
    init = function()
      -- Route gq through conform.
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

      vim.api.nvim_create_user_command("FormatDisable", function(args)
        if args.bang then
          vim.b.disable_autoformat = true
        else
          vim.g.disable_autoformat = true
        end
      end, { desc = "Disable format-on-save (! for this buffer only)", bang = true })

      vim.api.nvim_create_user_command("FormatEnable", function()
        vim.b.disable_autoformat = false
        vim.g.disable_autoformat = false
      end, { desc = "Re-enable format-on-save" })
    end,
  },
}
