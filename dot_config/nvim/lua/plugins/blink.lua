return {
  {
    "saghen/blink.cmp",
    -- Pinned to a release tag so lazy downloads the prebuilt fuzzy-matcher
    -- binary. Building from source needs cargo, which is not installed here.
    version = "1.*",
    -- Deliberately not lazy-loaded: blink self-lazies its heavy parts, and
    -- lsp.lua needs get_lsp_capabilities() at BufReadPre anyway.
    opts = {
      keymap = {
        preset = "none",
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
        -- select_and_accept mirrors nvim-cmp's confirm({ select = true }):
        -- take the first item when nothing is explicitly selected.
        ["<CR>"] = { "select_and_accept", "fallback" },
        ["<C-space>"] = { "show", "hide" },
        ["<C-e>"] = { "cancel", "fallback" },
      },
      sources = {
        default = { "lsp", "snippets", "buffer", "path" },
      },
      completion = {
        list = { selection = { preselect = true, auto_insert = false } },
      },
    },
  },
}
