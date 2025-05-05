{ config, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    clock24 = true;
    mouse = true;
    shell = "${pkgs.zsh}/bin/zsh";

    extraConfig = ''
      set -g history-limit 100000
      setw -g automatic-rename on
      bind r source-file ~/.tmux.conf \; display-message "Reloaded tmux config"
      set -g default-terminal "screen-256color"
    '';
  };
}
