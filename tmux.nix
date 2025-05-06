{ config, pkgs, ... }:

let
  tmuxPlugins = pkgs.tmuxPlugins;
in {
  programs.tmux = {
    enable    = true;
    shortcut  = "a";
    baseIndex = 1;
    keyMode   = "vi";
    mouse     = true;
    clock24   = true;
    shell     = "${pkgs.zsh}/bin/zsh";
    plugins   = with tmuxPlugins; [ sensible yank prefix-highlight nord ];
    
    extraConfig = ''
      set-option -g status-style bg=colour235,fg=colour136
      set-option -g pane-active-border-style fg=blue
      set -g history-limit 100000
      setw -g automatic-rename on
      bind r source-file ~/.tmux.conf \; display-message "Reloaded tmux config"
      set -g default-terminal "screen-256color"
    '';
  };
}
