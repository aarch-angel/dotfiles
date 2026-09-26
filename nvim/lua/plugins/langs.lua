return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        -- BUG: remove lua_ls verstion pin when this bug is resolved: https://github.com/LuaLS/lua-language-server/issues/3301#issuecomment-3618079510
        -- apparently this gives an error? it seemed to install the right version idek man
        -- "lua_ls@3.15.0",
        "stylua",
        "shellcheck",
        "shfmt",
        "djlint",
        -- "kotlin-lsp",
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        cssls = {},
        clangd = {
          capabilities = {
            -- Disable built in clangd formatting so clang-format can be used directly
            documentFormattingProvider = false,
            documentRangeFormattingProvider = false,
          },
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--fallback-style=microsoft",
          },
        },
        glsl_analyzer = {},
        -- BUG: mason installing julials breaks it, so install it manually - see:
        julials = {
          mason = false,
        },
        -- kotlin_language_server = false,
      },
      -- configs = {
      --   devicetree_ls = {
      --     default_config = {
      --       cmd = { "devicetree-language-server", "--stdio" },
      --       filetypes = { "dts", "dtsi" },
      --       root_dir = lspconfig.util.root_pattern("zephyr", ".git", "."),
      --       settings = {
      --         devicetree = {
      --           defaultIncludePaths = {
      --             "./zephyr/dts",
      --             "./zephyr/dts/arm",
      --             "./zephyr/dts/arm64/",
      --             "./zephyr/dts/riscv",
      --             "./zephyr/dts/common",
      --             "./zephyr/dts/vendor",
      --             "./zephyr/include",
      --           },
      --           cwd = "${workspaceFolder}",
      --           defaultBindingType = "Zephyr",
      --           defaultZephyrBindings = {
      --             "./zephyr/dts/bindings",
      --           },
      --           autoChangeContext = true,
      --           allowAdhocContexts = true,
      --           contexts = {},
      --         },
      --       },
      --       capabilities = capabilities,
      --     },
      --   },
      -- },
      setup = {
        -- Prevent mason lsp conflicting with rustaceanvim
        rust_analyzer = function()
          return true
        end,

        -- kotlin_lsp = function()
        --   return true
        -- end,

        cssls = function()
          --Enable (broadcasting) snippet capability for completion
          local capabilities = vim.lsp.protocol.make_client_capabilities()
          capabilities.textDocument.completion.completionItem.snippetSupport = true

          vim.lsp.config("cssls", {
            capabilities = capabilities,
          })
        end,
      },
    },
  },

  -- {
  --   "nvim-treesitter/nvim-treesitter",
  --   -- don't overwrite default config
  --   opts = function(_, opts)
  --     vim.list_extend(opts.ensure_installed, {
  --       "julia",
  --       "css",
  --       "glsl",
  --     })
  --   end,
  -- },

  {
    "stevearc/conform.nvim",
    opts = {
      -- log_level = vim.log.levels.DEBUG,
      formatters_by_ft = {
        htmldjango = { "djlint" },
        c = { "clang-format" },
        cpp = { "clang-format" },
      },
      formatters = {
        ["clang-format"] = {
          prepend_args = {
            -- TODO: make this dynamically get the config dir
            "--style=file:/home/aarchangel/Dotfiles/nvim/lua/plugins/clang-format.txt",
            "--fallback-style=microsoft", -- fallback if no config
          },
        },
      },
    },
  },

  -- {
  --   "AlexandrosAlexiou/kotlin.nvim",
  --   ft = { "kotlin" },
  --   dependencies = {
  --     "mason.nvim",
  --     "mason-lspconfig.nvim",
  --     "trouble.nvim",
  --   },
  --   config = function()
  --     require("kotlin").setup({
  --       -- Optional: Specify root markers for multi-module projects
  --       root_markers = {
  --         "gradlew",
  --         ".git",
  --         "mvnw",
  --         "settings.gradle",
  --       },
  --
  --       -- Optional: Java Runtime to run the kotlin-lsp server itself
  --       -- NOT REQUIRED when using Mason (kotlin-lsp v261+ includes bundled JRE)
  --       -- Priority: 1. jre_path, 2. Bundled JRE (Mason), 3. System java
  --       --
  --       -- Use this if you want to run kotlin-lsp with a specific Java version
  --       -- Must point to JAVA_HOME (directory containing bin/java)
  --       -- Examples:
  --       --   macOS:   "/Library/Java/JavaVirtualMachines/jdk-21.jdk/Contents/Home"
  --       --   Linux:   "/usr/lib/jvm/java-21-openjdk"
  --       --   Windows: "C:\\Program Files\\Java\\jdk-21"
  --       --   Env var: os.getenv("JAVA_HOME") or os.getenv("JDK21")
  --       jre_path = nil, -- Use bundled JRE (recommended)
  --
  --       -- Optional: JDK for symbol resolution (analyzing your Kotlin code)
  --       -- This is the JDK that your project code will be analyzed against
  --       -- Different from jre_path (which runs the server)
  --       -- Required for: Analyzing JDK APIs, standard library symbols, platform types
  --       --
  --       -- Usually should match your project's target JDK version
  --       -- Examples:
  --       --   macOS:   "/Library/Java/JavaVirtualMachines/jdk-17.jdk/Contents/Home"
  --       --   Linux:   "/usr/lib/jvm/java-17-openjdk"
  --       --   Windows: "C:\\Program Files\\Java\\jdk-17"
  --       --   SDKMAN:  os.getenv("HOME") .. "/.sdkman/candidates/java/17.0.8-tem"
  --       jdk_for_symbol_resolution = nil, -- Auto-detect from project
  --
  --       -- Optional: Specify additional JVM arguments for the kotlin-lsp server
  --       jvm_args = {
  --         "-Xmx1g", -- Increase max heap (useful for large projects)
  --       },
  --     })
  --   end,
  -- },

  { "nmac427/guess-indent.nvim" },

  { "tenxsoydev/tabs-vs-spaces.nvim", config = true },

  { "timtro/glslView-nvim", ft = { "glsl" } },

  -- systemd highlighting
  { "wgwoods/vim-systemd-syntax", ft = { "systemd" } },

  {
    "RaafatTurki/hex.nvim",
    config = function()
      -- defaults
      require("hex").setup({

        -- cli command used to dump hex data
        dump_cmd = "xxd -g 1 -u",

        -- cli command used to assemble from hex data
        assemble_cmd = "xxd -r",

        -- function that runs on BufReadPre to determine if it's binary or not
        is_file_binary_pre_read = function()
          -- logic that determines if a buffer contains binary data or not
          -- must return a bool
        end,

        -- function that runs on BufReadPost to determine if it's binary or not
        is_file_binary_post_read = function()
          -- logic that determines if a buffer contains binary data or not
          -- must return a bool
        end,
      })
    end,
  },

  -- Markdown Preview using pnpm
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && npm install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },

  {
    "epwalsh/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
    event = {
      -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
      -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
      -- refer to `:h file-pattern` for more examples
      "BufReadPre " .. vim.fn.expand("~") .. "/Dropbox/Obsidian/**/*.md",
      "BufNewFile " .. vim.fn.expand("~") .. "/Dropbox/Obsidian/**/*.md",
    },
    dependencies = {
      -- Required.
      "nvim-lua/plenary.nvim",
    },
    opts = {
      workspaces = {
        {
          name = "default",
          path = "~/Dropbox/Obsidian/Default Vault",
        },
      },
    },
  },
}
