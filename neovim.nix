{ config, pkgs, ... }:

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
      tokyonight-nvim   # 🎨 NEW: Add your colorscheme plugin here
    ];

    extraLuaConfig = ''
      vim.opt.number = true
      vim.cmd("syntax on")

      -- Set leader key (optional)
      vim.g.mapleader = " "

      -- Set the colorscheme
      vim.cmd.colorscheme("tokyonight")

      -- Optional: style tweaks
      vim.opt.termguicolors = true
      vim.opt.background = "dark" -- or "light"
    '';
  };

  home.packages = with pkgs; [
    lazygit
  ];
}
