return {
  {
    "neovim/nvim-lspconfig",
    lazy = false, -- load at startup so servers can attach immediately
    dependencies = {
      { "folke/lazydev.nvim", ft = "lua" },
    },
  },
}
