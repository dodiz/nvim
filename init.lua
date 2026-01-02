vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.number = true
vim.opt.relativenumber = true
vim.g.mapleader = " "

-- Sync clipboard with OS
vim.opt.clipboard = "unnamedplus"

vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })

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
    'nvim-telescope/telescope.nvim', tag = '*',
    dependencies = {'nvim-lua/plenary.nvim', { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }}
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
        ensure_installed = {"lua", "javascript", "typescript", "rust", "html", "json", "css"},
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
    lazy = false, -- neo-tree will lazily load itself
  }
}

require("lazy").setup({
  spec = plugins,
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { 
    colorscheme = { "koehler" } 
  },
  -- automatically check for plugin updates
  checker = { enabled = true },
})
 
-- Telescope 
local telescope = require("telescope.builtin")
vim.keymap.set("n", "<C-p>", telescope.find_files, {})
vim.keymap.set("n", "<leader>fg", telescope.live_grep, {})

-- Neotree
vim.keymap.set("n", "<leader>f", "Neotree toggle right<CR>")
