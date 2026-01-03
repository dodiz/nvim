vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.number = true
vim.opt.relativenumber = true
vim.g.mapleader = " "

-- Sync clipboard with OS
vim.opt.clipboard = "unnamedplus"

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd("colorscheme kanagawa-dragon")
    end
  },
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
    }
  },
  --Treesitter 
  {
    "nvim-treesitter/nvim-treesitter",
    branch = 'master',
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local config = require("nvim-treesitter.configs")
      config.setup({
        ensure_installed = { "lua", "javascript", "typescript", "rust", "html", "json", "css", "tsx" },
        highlight = { enable = true },
        indent = { enable = true }
      })
    end
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    lazy = false,
    config = function()
      require("neo-tree").setup({
        window = {
          position = "right"
        }
      })
    end
  },
  -- Lualine
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require("lualine").setup({
        theme = "codedark"
      })
    end
  },
  {
    "kdheepak/lazygit.nvim",
    lazy = true,
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    -- optional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
      { "<leader>g", "<cmd>LazyGit<cr>", desc = "LazyGit" }
    }
  },
  -- Mason LSP
  {
    "mason-org/mason.nvim",
    config = function()
      require("mason").setup()
    end
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "ts_ls" },
        handlers = {
          -- The default handler (applies to everything without a specific config)
          function(server_name)
            require("lspconfig")[server_name].setup({})
          end,
        }
      })
    end
  },
  {
    "neovim/nvim-lspconfig",
  },
  {
    "nvim-telescope/telescope-ui-select.nvim"
  }
}

-- End plugins

require("lazy").setup({
  spec = plugins,
  install = {
    colorscheme = { "kanagawa" }
  },
  -- automatically check for plugin updates
  checker = { enabled = true },
})

-- Keybinds

-- Save
vim.keymap.set("n", "<C-s>", ":w<CR>", { desc = "Save" })
-- Remove selection
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
-- Select all
vim.keymap.set("n", "<C-a>", "ggVG", { desc = "Select all" })

-- Move lines
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })

-- Telescope
local telescope = require("telescope.builtin")
vim.keymap.set("n", "<leader>p", telescope.find_files, {})
vim.keymap.set("n", "<leader>f", telescope.live_grep, {})
vim.keymap.set("n", "<leader>h", telescope.keymaps, {})

-- Neotree file explorer
vim.keymap.set("n", "<leader>a", ":Neotree toggle right<CR>", { silent = true })

-- Lsp
vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
vim.keymap.set("n", "<leader>j", vim.lsp.buf.definition, {})
vim.keymap.set({ "n", "v" }, "<leader>c", vim.lsp.buf.code_action, {})

