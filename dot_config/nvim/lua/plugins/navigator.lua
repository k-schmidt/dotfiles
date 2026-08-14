-- Ctrl+h/j/k/l moves between Neovim splits and tmux panes interchangeably, so
-- crossing the editor/terminal boundary stops being a separate motion.
-- Requires the matching if-shell bindings in ~/.tmux.conf; without tmux the
-- commands degrade to plain window navigation, so this is safe standalone.
return {
  {
    "christoomey/vim-tmux-navigator",
    -- keys lazy-loads this; cmd covers invoking the commands directly.
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<C-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Pane/split left" },
      { "<C-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Pane/split down" },
      { "<C-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Pane/split up" },
      { "<C-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Pane/split right" },
      { "<C-\\>", "<cmd>TmuxNavigatePrevious<cr>", desc = "Pane/split previous" },
    },
  },
}
