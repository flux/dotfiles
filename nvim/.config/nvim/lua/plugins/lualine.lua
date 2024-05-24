return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "catppuccin",
        },
        sections = {
          lualine_c = {
            { "filename", path = 1 },
          },
          lualine_x = {
            -- "encoding",
            -- { "fileformat", icons_enabled = false },
            "filetype",
          },
        },
      })

      require("lualine").get_config()
    end,
  },
}
