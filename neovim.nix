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
      # Add more plugins here as needed
    ];

    extraConfig = ''
      set number
      syntax on
    '';
  };
}
