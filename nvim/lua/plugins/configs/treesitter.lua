return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    -- You can keep your setup options here
    require("nvim-treesitter").setup({
      -- Add your configuration options here
      ensure_installed = { "lua", "vim", "vimdoc", "query", "javascript", "typescript", "c", "cpp", "python", "rust", "go", "java", "html", "css", "bash", "markdown", "json", "yaml" },
      auto_install = true,
      highlight = {
        enable = true,
      },
      indent = {
        enable = true,
      },
    })
  end,
}
