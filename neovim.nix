{ config, pkgs, lib, ... }:

{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
      vim-nix
      telescope-nvim
      lazygit-nvim
      nvim-treesitter
      tokyonight-nvim
      lualine-nvim
      nvim-web-devicons
      nvim-colorizer-lua
      which-key-nvim
      plenary-nvim
    ];

    extraLuaConfig = ''
      vim.g.mapleader = ' '
      vim.g.lazy_show_on_start = false
      vim.opt.mouse = "a"
      vim.opt.clipboard = "unnamedplus"
      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.termguicolors = true
      vim.opt.background = "dark"

      pcall(vim.api.nvim_del_keymap, 'n', 'gc')
      pcall(vim.api.nvim_del_keymap, 'v', 'gc')

      local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
      if not vim.loop.fs_stat(lazypath) then
        vim.fn.system({
          "git", "clone", "--filter=blob:none",
          "https://github.com/folke/lazy.nvim.git",
          "--branch=stable", lazypath
        })
      end
      vim.opt.rtp:prepend(lazypath)

      require("lazy").setup({
        {
          "folke/which-key.nvim",
          event = "VimEnter",
          opts = {
            plugins = {
              presets = {
                operators = true,
                motions = true,
                text_objects = true,
                windows = true,
                nav = true,
                z = true,
                g = true,
              },
            },
            icons = {
              breadcrumb = "»",
              separator = "➜",
              group = "+",
            },
          },
          keys = {
            { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find File" },
            { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Find Text" },
            { "<leader>:", "<cmd>Telescope commands<cr>", desc = "Command Palette" },
            { "<leader>e", "<cmd>Telescope file_browser<cr>", desc = "File Browser" },
            { "<leader>n", "<cmd>NvimTreeToggle<cr>", desc = "Toggle File Explorer" },
            { "<leader>f",  name = "+file" },
            { "<leader>g",  name = "+git" },
            { "<leader>b",  name = "+buffer" },
            { "<leader>w",  name = "+window" },
            { "<leader>d",  name = "+diagnostics" },
            { "<leader>l",  name = "+lsp" },
            { "<leader>h",  name = "+help" }
          }
        },
        {
          "nvim-tree/nvim-web-devicons",
          lazy = false
        },
        {
          "folke/tokyonight.nvim",
          lazy = false,
          priority = 1000,
          config = function()
            vim.cmd.colorscheme("tokyonight")
          end
        },
        {
          "nvim-telescope/telescope-file-browser.nvim",
          dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
        },
        {
          "nvim-tree/nvim-tree.lua",
          dependencies = { "nvim-tree/nvim-web-devicons" },
          config = function()
            require("nvim-tree").setup()
            vim.api.nvim_set_keymap("n", "<leader>n", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
          end
        },
        {
          "akinsho/bufferline.nvim",
          version = "*",
          dependencies = { "nvim-tree/nvim-web-devicons" },
          config = function()
            require("bufferline").setup{}
            vim.opt.termguicolors = true
            vim.opt.showtabline = 2
          end
        }
      })

      local function mem_usage()
        local output = vim.fn.system("free -h | awk 'NR==2{print $3\"/\"$2}'")
        return output:gsub("\n", "")
      end
      local function cpu_usage()
        local stat1 = vim.fn.split(vim.fn.system('cat /proc/stat | grep "^cpu "'), " ")
        local total1 = 0 for i=2,#stat1 do total1 = total1 + tonumber(stat1[i]) end
        local idle1 = tonumber(stat1[5])
        vim.fn.system('sleep 0.5')
        local stat2 = vim.fn.split(vim.fn.system('cat /proc/stat | grep "^cpu "'), " ")
        local total2 = 0 for i=2,#stat2 do total2 = total2 + tonumber(stat2[i]) end
        local idle2 = tonumber(stat2[5])
        return math.floor((total2 - total1 - (idle2 - idle1)) / (total2 - total1) * 100) .. '%'
      end

      require('lualine').setup {
        options = {
          theme = 'tokyonight',
          section_separators = { left = '', right = '' },
          component_separators = { left = '', right = '' },
          icons_enabled = true,
        },
        sections = {
          lualine_a = {'mode'},
          lualine_b = {'branch', 'diff', 'diagnostics'},
          lualine_c = {{'filename', path = 1}},
          lualine_x = {'encoding', 'fileformat', 'filetype', cpu_usage},
          lualine_y = {'progress', mem_usage},
          lualine_z = {'location'},
        },
      }

      require('colorizer').setup({"*"}, { RGB = true, RRGGBB = true, names = true })
    '';
  };

  home.packages = with pkgs; [
    lazygit
    ripgrep
    fd
    unzip
    git
  ];
}
