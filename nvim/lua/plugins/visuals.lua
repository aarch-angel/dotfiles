return {
  -- These are somewhat sorted in an order that makes sense to me.

  -- add theme
  { "akinsho/horizon.nvim" },
  -- { "lancewilhelm/horizon-extended.nvim" },
  -- { "challenger-deep-theme/vim" },
  -- { "maxmx03/dracula.nvim" },
  -- { "Jas-SinghFSU/drappuccin" },
  -- { "catppuccin/nvim" },

  -- configure to use theme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "horizon",
    },
  },
  {
    "cohml/todo-comments.nvim",
    branch = "feat/keyword-padding",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      highlight = {
        multiline = false,
        -- https://github.com/folke/todo-comments.nvim/pull/199#issuecomment-2049436802
        -- pattern = [[.{-}<(\s?(KEYWORDS):)]],
        before = "",
        keyword = "bg",
        after = "",

        padding = { -- padding characters around keywords
          enabled = true, -- enable padding feature
          left = "", -- left padding character(s)
          right = "", -- right padding character(s)
          hide_colon = true, -- hide the colon after the keyword
          hide_on_cursor = true, -- hide padding when cursor is on the line
        },
      },

      keywords = {
        WARN = {
          padding = {
            left = "█",
            right = "█ ",
          },
        },
        FIX = {
          padding = {
            left = "█",
            right = "█",
          },
        },
        NOTE = {
          padding = {
            left = "█",
            right = "█ ",
          },
        },
      },
    },
  },

  { "akinsho/bufferline.nvim", enabled = false },

  -- Scrollbar that shows signs
  {
    "dstein64/nvim-scrollview",
    opts = {
      signs_on_startup = { "all" },
    },
  },

  {
    "HiPhish/rainbow-delimiters.nvim",
    config = function()
      -- Run :so $VIMRUNTIME/syntax/hitest.vim to see highlight groups
      require("rainbow-delimiters.setup").setup({
        -- Not needed in horizon theme
        -- highlight = {
        --   "RainbowRed",
        --   "RainbowYellow",
        --   "RainbowBlue",
        --   "RainbowOrange",
        --   "RainbowGreen",
        --   "RainbowViolet",
        --   "RainbowCyan",
        -- },
      })
    end,
  },

  {
    "esmuellert/codediff.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    cmd = "CodeDiff",
  },

  -- {
  --   "tris203/precognition.nvim",
  --   opts = {
  --     -- startVisible = true,
  --     showBlankVirtLine = false,
  --     highlightColor = { link = "@annotation" },
  --     -- hints = {
  --     --      Caret = { text = "^", prio = 2 },
  --     --      Dollar = { text = "$", prio = 1 },
  --     --      MatchingPair = { text = "%", prio = 5 },
  --     --      Zero = { text = "0", prio = 1 },
  --     --      w = { text = "w", prio = 10 },
  --     --      b = { text = "b", prio = 9 },
  --     --      e = { text = "e", prio = 8 },
  --     --      W = { text = "W", prio = 7 },
  --     --      B = { text = "B", prio = 6 },
  --     --      E = { text = "E", prio = 5 },
  --     -- },
  --     -- gutterHints = {
  --     --     G = { text = "G", prio = 10 },
  --     --     gg = { text = "gg", prio = 9 },
  --     --     PrevParagraph = { text = "{", prio = 8 },
  --     --     NextParagraph = { text = "}", prio = 8 },
  --     -- },
  --     -- disabled_fts = {
  --     --     "startify",
  --     -- },
  --   },
  -- },

  {
    "skwee357/nvim-prose",
    opts = {
      wpm = 200.0,
      filetypes = { "markdown", "asciidoc" },
      placeholders = {
        words = "words",
        minutes = "min",
      },
    },
  },
}
