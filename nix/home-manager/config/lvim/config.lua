--[[
 THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT
 `lvim` is the global options object
]]
-- vim options
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.relativenumber = true

-- When using nix we can not put mutable files in the same
-- location as the nix-owned config files. Forgo the risk of
-- not being able to ensure consistency across machines
lvim.lazy.opts.lockfile = require("lvim.utils").join_paths(get_cache_dir(), "lazy-lock.json")
lvim.builtin.dap.ui.auto_open = false

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

-- general
lvim.log.level = "info"
lvim.format_on_save = {
  enabled = true,
  pattern = "*.lua",
  timeout = 1000,
}
-- to disable icons and use a minimalist setup, uncomment the following
-- lvim.use_icons = false

-- keymappings <https://www.lunarvim.org/docs/configuration/keybindings>
lvim.leader = "space"

-- add your own keymapping
-- lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"

-- -- Use which-key to add extra bindings with the leader-key prefix
lvim.builtin.which_key.setup.plugins.presets.z = true
lvim.builtin.which_key.setup.plugins.presets.windows = true
lvim.builtin.which_key.setup.plugins.presets.motions = true
lvim.builtin.which_key.setup.plugins.presets.nav = true
lvim.builtin.which_key.setup.plugins.presets.text_objects = true
lvim.builtin.which_key.mappings["t"] = {
  name = "Diagnostics",
  t = { "<cmd>TroubleToggle<cr>", "trouble" },
  w = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "workspace" },
  d = { "<cmd>TroubleToggle document_diagnostics<cr>", "document" },
  q = { "<cmd>TroubleToggle quickfix<cr>", "quickfix" },
  l = { "<cmd>TroubleToggle loclist<cr>", "loclist" },
  r = { "<cmd>TroubleToggle lsp_references<cr>", "references" },
}

lvim.builtin.which_key.mappings["lL"] = {
  "<cmd>lua require'lsp_lines'.toggle()<CR>", "Toggle Multiline"
}
-- Neoclip
lvim.builtin.which_key.mappings["\""] = {
  "<cmd>Telescope neoclip plus<CR>", "Neoclip"
}

lvim.builtin.treesitter.textobjects = {
  select = {
    enable = true,
    -- Automatically jump forward to textobj, similar to targets.vim
    lookahead = true,
    keymaps = {
      -- You can use the capture groups defined in textobjects.scm
      ["af"] = { query = "@function.outer", desc = "Func body + def" },
      ["if"] = { query = "@function.inner", desc = "Func body" },
      ["ac"] = { query = "@class.outer", desc = "Class body + def" },
      ["ic"] = { query = "@class.inner", desc = "Class body" },
      ["aa"] = { query = "@parameter.outer", desc = "Param" },
      ["ia"] = { query = "@parameter.inner", desc = "Param name" },
      ["a/"] = { query = "@comment.outer", desc = "Line comment" },
    },
  },
}

-- lvim.builtin.which_key.mappings["o"] = {
--   name = "Org",
--   -- Populated by nvim-orgmode plugin
-- }

-- Change theme settings
lvim.colorscheme = "catppuccin"

lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = true

-- Automatically install missing parsers when entering buffer
lvim.builtin.treesitter.auto_install = true

lvim.builtin.dap.active = true
lvim.builtin.telescope.on_config_done = function(telescope)
  pcall(telescope.load_extension, 'ui-select')
  pcall(telescope.load_extension, "neoclip")
end

-- lvim.builtin.treesitter.ignore_install = { "haskell" }

-- -- always installed on startup, useful for parsers without a strict filetype
-- lvim.builtin.treesitter.ensure_installed = { "comment", "markdown_inline", "regex" }

-- -- generic LSP settings <https://www.lunarvim.org/docs/languages#lsp-support>

-- --- disable automatic installation of servers
-- lvim.lsp.installer.setup.automatic_installation = false

-- ---configure a server manually. IMPORTANT: Requires `:LvimCacheReset` to take effect
-- ---see the full default list `:lua =lvim.lsp.automatic_configuration.skipped_servers`
-- vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "pyright" })
-- local opts = {} -- check the lspconfig documentation for a list of all possible options
-- require("lvim.lsp.manager").setup("pyright", opts)

-- ---remove a server from the skipped list, e.g. eslint, or emmet_ls. IMPORTANT: Requires `:LvimCacheReset` to take effect
-- ---`:LvimInfo` lists which server(s) are skipped for the current filetype
-- lvim.lsp.automatic_configuration.skipped_servers = vim.tbl_filter(function(server)
--   return server ~= "emmet_ls"
-- end, lvim.lsp.automatic_configuration.skipped_servers)

-- -- you can set a custom on_attach function that will be used for all the language servers
-- -- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
-- lvim.lsp.on_attach_callback = function(client, bufnr)
--   local function buf_set_option(...)
--     vim.api.nvim_buf_set_option(bufnr, ...)
--   end
--   --Enable completion triggered by <c-x><c-o>
--   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
-- end

-- -- linters and formatters <https://www.lunarvim.org/docs/languages#lintingformatting>
-- local formatters = require "lvim.lsp.null-ls.formatters"
-- formatters.setup {
--   { command = "stylua" },
--   {
--     command = "prettier",
--     extra_args = { "--print-width", "100" },
--     filetypes = { "typescript", "typescriptreact" },
--   },
-- }
-- local linters = require "lvim.lsp.null-ls.linters"
-- linters.setup {
--   { command = "flake8", filetypes = { "python" } },
--   {
--     command = "shellcheck",
--     args = { "--severity", "warning" },
--   },
-- }

-- -- Additional Plugins <https://www.lunarvim.org/docs/plugins#user-plugins>
-- lvim.plugins = {
--     {
--       "folke/trouble.nvim",
--       cmd = "TroubleToggle",
--     },
-- }
lvim.plugins = {
  {
    "scalameta/nvim-metals",
    config = function()
      require("user.metals").config()
    end,
    ft = { "scala", "sc", "sbt" },
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
    }
  },
  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
  },
  {
    "nvim-telescope/telescope-ui-select.nvim"
  },
  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
  },
  -- lightspeed replacement
  {
    "ggandor/leap.nvim",
    name = "leap",
    dependencies = {
      "tpope/vim-repeat"
    },
    config = function()
      require("leap").add_default_mappings()
    end,
  },
  -- f t on steroids, consider this in the future
  -- {
  --   "ggandor/flit.nvim",
  --   dependencies = {
  --     "ggandor/leap.nvim",
  --     "tpope/vim-repeat"
  --   },
  --   config = function()
  --     require("flit").setup({})
  --   end,
  -- },
  {
    "nvim-treesitter/nvim-treesitter-textobjects"
  },
  {
    "romgrk/nvim-treesitter-context",
    config = function()
      require("treesitter-context").setup {
        enable = true,   -- Enable this plugin (Can be enabled/disabled later via commands)
        throttle = true, -- Throttles plugin updates (may improve performance)
        max_lines = 0,   -- How many lines the window should span. Values <= 0 mean no limit.
        patterns = {
          -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
          -- For all filetypes
          -- Note that setting an entry here replaces all other patterns for this entry.
          -- By setting the 'default' entry below, you can control which nodes you want to
          -- appear in the context window.
          default = {
            'class',
            'function',
            'method',
          },
        },
      }
    end
  },
  {
    "nvim-neorg/neorg",
    enabled = true,
    build = ":Neorg sync-parsers",
    opts = {
      load = {
        ["core.defaults"] = {},  -- Loads default behaviour
        ["core.concealer"] = {}, -- Adds pretty icons to your documents
        ["core.keybinds"] = {
          config = {
            default_keybinds = true,
            neorg_leader = '<Space>n',
          },
        },
        ["core.dirman"] = { -- Manages Neorg workspaces
          config = {
            workspaces = {
              notes = "~/notes",
            },
          },
        },
      },
    },
    dependencies = { { "nvim-lua/plenary.nvim" } },
  },
  {
    "epwalsh/obsidian.nvim",
    config = function(_, opts)
      require("obsidian").setup(opts)
    end,

  },
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        keymaps = {
          insert = "<C-g>s",
          insert_line = "<C-g>S",
          normal = "ys",
          normal_cur = "yss",
          normal_line = "yS",
          normal_cur_line = "ySS",
          visual = "gs",
          visual_line = "gS",
          delete = "ds",
          change = "cs",
          change_line = "cS",
        }
      })
    end
  },
  {
    url = "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    enabled = true,
    config = function()
      require("lsp_lines").setup()
      -- Disable on start. Can be toggled on
      vim.diagnostic.config({ virtual_lines = false })
    end
  },
  {
    "zbirenbaum/copilot-cmp",
    event = "InsertEnter",
    dependencies = { "zbirenbaum/copilot.lua" },
    config = function()
      vim.defer_fn(function()
        require("copilot").setup()
        require("copilot_cmp").setup()
      end, 100)
    end,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      flavour = "mocha",
      transparent_background = true,
    }
  },
  -- Database explorer / Datagrip replacement
  {
    "tpope/vim-dadbod"
  },
  {
    "kristijanhusak/vim-dadbod-ui"
  },
  {
    "kristijanhusak/vim-dadbod-completion"
  },
  {
    "David-Kunz/gen.nvim"
  },
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end,
  },
  {
    "ellisonleao/glow.nvim",
    config = true,
    cmd = "Glow"
  },
  {
    "tversteeg/registers.nvim",
    name = "registers",
    keys = {
      { "\"",    mode = { "n", "v" } },
      { "<C-R>", mode = "i" }
    },
    cmd = "Registers",
    config = function()
      require('registers').setup({})
    end,
  },
  {
    "AckslD/nvim-neoclip.lua",
    dependencies = {
      'nvim-telescope/telescope.nvim',
      {
        'kkharji/sqlite.lua',
        module = 'sqlite'
      },
    },
    config = function()
      require('neoclip').setup({
        history = 1000,
        enable_persistent_history = true,
        length_limit = 1048576,
        continuous_sync = true,
      })
    end,
  },
}

require("dap").configurations.scala = {
  {
    type = "scala",
    request = "launch",
    name = "Run or Test Target",
    metals = {
      runType = "runOrTestFile",
    },
  },
  {
    type = "scala",
    request = "launch",
    name = "Test Target",
    metals = {
      runType = "testTarget",
    },
  },
}

local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "<c-s>", "<cmd>lua require('copilot.suggestion').toggle_auto_trigger()<CR>", opts)


-- -- Autocommands (`:help autocmd`) <https://neovim.io/doc/user/autocmd.html>
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "zsh",
--   callback = function()
--     -- let treesitter use bash highlight for zsh files as well
--     require("nvim-treesitter.highlight").attach(0, "bash")
--   end,
-- })
vim.api.nvim_create_autocmd("BufReadPost", {
  command = "set foldlevel=99"
})
