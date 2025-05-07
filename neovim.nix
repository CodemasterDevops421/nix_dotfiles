{ config, pkgs, lib, ... }:

{
  ##################################################
  # Neovim Configuration
  ##################################################
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    # Core plugins and colorscheme
    plugins = with pkgs.vimPlugins; [
      vim-nix
      telescope-nvim
      lazygit-nvim
      nvim-treesitter
      tokyonight-nvim    # 🎨 Colorscheme
      lualine-nvim       # 🌈 Statusline
      nvim-web-devicons  # 📦 File icons
      nvim-colorizer-lua # 🎨 Inline colorizer
      which-key-nvim     # 🗝️ Keybinding hints
    ];

    extraLuaConfig = ''
      -- Set leader key
      vim.g.mapleader = ' '

      -- Basic UI settings
      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.termguicolors = true
      vim.opt.background = "dark"
      vim.cmd.colorscheme("tokyonight")

      -- System usage functions for Lualine
      local function mem_usage()
        local output = vim.fn.system("free -h | awk 'NR==2{print $3\"/\"$2}'")
        return output:gsub("\\n", "")
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

      -- Lualine setup
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

      -- Telescope keybindings
      vim.api.nvim_set_keymap('n', '<Leader>ff', ":Telescope find_files<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<Leader>fg', ":Telescope live_grep<CR>", { noremap = true, silent = true })

      -- Colorizer setup
      require('colorizer').setup({'*'}, { RGB = true, RRGGBB = true, names = true })

      -- Which-key setup
      local wk = require('which-key')
      wk.setup {
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
          breadcrumb = '»',
          separator = '➜',
          group = '+',
        },
      }
      wk.register({
        f = { name = 'file',    n = {'<cmd>enew<cr>', 'New File'}, f = {'<cmd>e .<cr>', 'Find File'}, s = {'<cmd>w<cr>', 'Save File'} },
        g = { name = 'git',     s = {'<cmd>Git<cr>', 'Status'}, c = {'<cmd>Git commit<cr>', 'Commit'} },
        b = { name = 'buffer',   b = {'<cmd>ls<cr>', 'List Buffers'}, n = {'<cmd>bn<cr>', 'Next Buffer'}, p = {'<cmd>bp<cr>', 'Prev Buffer'} },
        w = { name = 'window',   s = {'<cmd>split<cr>', 'Split H'}, v = {'<cmd>vsplit<cr>', 'Split V'}, c = {'<cmd>close<cr>', 'Close'} },
        d = { name = 'diagnostics', l = {'<cmd>lua vim.diagnostic.open_float()<cr>', 'Diag'}, p = {'<cmd>lua vim.diagnostic.goto_prev()<cr>', 'Prev'}, n = {'<cmd>lua vim.diagnostic.goto_next()<cr>', 'Next'} },
        l = { name = 'lsp',      r = {'<cmd>lua vim.lsp.buf.rename()<cr>', 'Rename'}, a = {'<cmd>lua vim.lsp.buf.code_action()<cr>', 'Action'}, g = {'<cmd>lua vim.lsp.buf.definition()<cr>', 'Def'} },
        h = { name = 'help',     h = {'<cmd>help<cr>', 'Help'}, k = {'<cmd>help keymap<cr>', 'Keymaps'}, m = {'<cmd>help manual<cr>', 'Manual'} },
      }, { prefix = '<leader>' })
    '';
  };

  ##################################################
  # Additional CLI tooling
  ##################################################
  home.packages = with pkgs; [
    lazygit
  ];
}
