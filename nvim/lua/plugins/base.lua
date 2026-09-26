return {

  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
  },

  {
    "vyfor/cord.nvim",
    build = ":Cord update",
    opts = {
      plugins = {
        "cord.plugins.diagnostics", -- Enable the diagnostics plugin
      },
      editor = {
        tooltip = "im cheating on emacs",
      },
      text = {
        editing = function(opts)
          local text = "Editing " .. opts.filename
          if vim.bo.modified then
            text = text .. " [+]"
          end
          return text
        end,
      },
      idle = {
        details = function(opts)
          return string.format("AFK from %s", opts.workspace)
        end,
      },
      buttons = {
        -- {
        --   label = "View Repository",
        --   url = function(opts)
        --     return opts.repo_url
        --   end,
        -- },
        {
          label = "Neovim Setup",
          url = "https://github.com/aarch-angel/dotfiles/tree/merge/nvim",
        },
      },
      display = {
        theme = "catppuccin",
        flavor = "dark",
      },
    },
  },

  -- { "Vigemus/iron.nvim" },

  -- {
  --   "lewis6991/hover.nvim",
  --   config = function()
  --     require("hover").setup({
  --       init = function()
  --         -- Require providers
  --         require("hover.providers.lsp")
  --         -- require("hover.providers.gh")
  --         -- require("hover.providers.gh_user")
  --         -- require('hover.providers.jira')
  --         require("hover.providers.dap")
  --         require("hover.providers.fold_preview")
  --         require("hover.providers.diagnostic")
  --         require("hover.providers.man")
  --         require("hover.providers.dictionary")
  --       end,
  --       preview_opts = {
  --         border = "single",
  --       },
  --       -- Whether the contents of a currently open hover window should be moved
  --       -- to a :h preview-window when pressing the hover keymap.
  --       preview_window = false,
  --       title = true,
  --       mouse_providers = {
  --         "LSP",
  --       },
  --       mouse_delay = 1000,
  --     })
  --   end,
  -- },

  -- Supertab
  {
    "hrsh7th/nvim-cmp",
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local cmp = require("cmp")

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            -- You could replace select_next_item() with confirm({ select = true }) to get VS Code autocompletion behavior
            cmp.select_next_item()
          elseif vim.snippet.active({ direction = 1 }) then
            vim.schedule(function()
              vim.snippet.jump(1)
            end)
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif vim.snippet.active({ direction = -1 }) then
            vim.schedule(function()
              vim.snippet.jump(-1)
            end)
          else
            fallback()
          end
        end, { "i", "s" }),
      })
    end,
  },

  {
    "https://codeberg.org/esensar/nvim-dev-container",
    config = function()
      require("devcontainer").setup({})
    end,
  },

  {
    "nvim-mini/mini.surround",
    opts = {
      respect_selection_type = true,
    },
  },
}
