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
    ];

    # Replace Vimscript with Lua
    extraLuaConfig = ''
      vim.opt.number = true
      vim.cmd("syntax on")

      -- Keybinding: <leader>gg to open LazyGit
      vim.keymap.set("n", "<leader>gg", ":LazyGit<CR>", { noremap = true, silent = true })
    '';
  };

  # Make sure lazygit CLI is installed
  home.packages = with pkgs; [
    lazygit
  ];
}
