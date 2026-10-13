-- art + three-pane layout live in lua/config/dashboard.lua
local dashboard = require("config.dashboard")

-- LazyVim UI
return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      picker = {
        sources = {
          -- hide the current buffer in the buffers picker (<leader>,)
          buffers = {
            current = false,
          },
        },
      },
      dashboard = {
        -- content under the header; dashboard.sections() adds the header, layout + side art.
        -- Use dashboard.keys/row/startup for rows that should span the content width
        sections = dashboard.sections({
          dashboard.keys({ gap = 1, padding = 4 }),
          -- {
          --   section = "terminal",
          --   cmd = "fortune /home/aarchangel/Dotfiles/resources/fortune/pod",
          --   height = 1,
          --   padding = 1,
          -- },
          -- {
          --   section = "terminal",
          --   cmd = "chafa ~/Dotfiles/resources/images/pod.png --format symbols --symbols vhalf --work 9",
          --   height = 24,
          --   padding = 1,
          -- },
          -- function(self)
          --   return {
          --     section = "terminal",
          --     icon = " ",
          --     title = "Git Status",
          --     cmd = "git --no-pager diff --stat -B -M -C",
          --     enabled = Snacks.git.get_root() ~= nil,
          --     width = dashboard.content_width(self) - 3, -- span the content, minus indent
          --     padding = 1,
          --     ttl = 5 * 60,
          --     indent = 3,
          --   }
          -- end,
          dashboard.row({
            icon = " ",
            desc = "Browse Repo",
            padding = 1,
            key = "b",
            enabled = function()
              return Snacks.git.get_root() ~= nil
            end,
            action = function()
              Snacks.gitbrowse()
            end,
          }),
          -- pinned to the window bottom (bottom = rows below the block's last line).
          -- Pinned items go last, in top-to-bottom order
          dashboard.quote({
            cmd = { "fortune", vim.fn.expand("~/Dotfiles/resources/fortune/girledm") },
            -- or pick from a list instead of a command:
            -- quotes = { "first quote", "second quote" },
            fg_group = "Function", -- theme group the italic quote copies its color from
            bottom = 4, -- one blank row above the startup line
          }),
          dashboard.startup({ bottom = 2 }),
        }),
      },
    },
    init = function()
      -- Neovide: disable float shadow/blur only while the dashboard is open
      if vim.g.neovide then
        local keys = {
          "neovide_floating_shadow",
          "neovide_floating_blur_amount_x",
          "neovide_floating_blur_amount_y",
          "neovide_floating_z_height",
        }
        local off = {
          neovide_floating_shadow = false,
          neovide_floating_blur_amount_x = 0,
          neovide_floating_blur_amount_y = 0,
          neovide_floating_z_height = 0,
        }
        local saved = {}

        vim.api.nvim_create_autocmd("User", {
          pattern = "SnacksDashboardOpened",
          callback = function()
            for _, k in ipairs(keys) do
              saved[k] = vim.g[k] -- may be nil if never set
              vim.g[k] = off[k]
            end
          end,
        })

        vim.api.nvim_create_autocmd("User", {
          pattern = "SnacksDashboardClosed",
          callback = function()
            for _, k in ipairs(keys) do
              vim.g[k] = saved[k] -- nil resets to Neovide default
            end
          end,
        })
      end

      -- Set highlight overrides when colorscheme loads
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = function()
          local highlights = {
            -- Main picker highlights
            SnacksPickerDir = "Directory",
            SnacksPickerPathHidden = "NeoTreeHiddenByName",
            SnacksPickerPathIgnored = "NeoTreeGitIgnored",

            -- Additional picker elements
            -- SnacksPickerBorder = "FloatBorder",
            -- SnacksPickerTitle = "FloatTitle",
            -- SnacksPickerIcon = "Special",
            -- SnacksPickerIconDir = "Directory",

            -- Git status
            SnacksPickerGitStatusUntracked = "GitSignsUntracked",
            SnacksPickerGitStatusModified = "DiagnosticWarn",
            SnacksPickerGitStatusRenamed = "GitSignsChange",
            SnacksPickerGitStatusDeleted = "GitSignsDelete",
            SnacksPickerGitStatusIgnored = "NeoTreeGitIgnored",
            SnacksPickerGitStatusAdded = "GitSignsAdd",
            SnacksPickerGitStatusStaged = "GitSignsAdd",

            -- Dashboard sections -> theme groups (tweak these groups to recolor)
            -- (the quote is set via fg_group in dashboard.quote above; side art stays Normal)
            SnacksDashboardHeader = "Keyword",
            SnacksDashboardIcon = "Special",
            SnacksDashboardDesc = "Normal",
            SnacksDashboardKey = "Keyword",
            SnacksDashboardFooter = "Comment",
            SnacksDashboardTitle = "Title",

            -- TODO: change to a better colour later
            RenderMarkdownCode = "Special",

            -- Scratch buffer <CR> output: default NonText is nearly invisible in horizon
            SnacksDebugPrint = "Normal",
            SnacksDebugIndent = "Comment",
          }

          for group, link in pairs(highlights) do
            vim.api.nvim_set_hl(0, group, { link = link })
          end
        end,
      })
    end,
  },
}
