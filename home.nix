{ config, pkgs, lib, ... }:

{
  ########################################
  # User & state
  ########################################
  home.username      = "chaithu";
  home.homeDirectory = "/home/chaithu";
  home.stateVersion  = "24.11";

  ########################################
  # Packages  (fonts moved here)
  ########################################
  home.packages = with pkgs; [
    neofetch  xclip   tmux    tree   zsh   dos2unix  ghostty  alacritty
    bat       fzf     eza     ripgrep zoxide bottom  starship sqlite

    nerd-fonts.hack
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
  ];

  ########################################
  # Z-shell
  ########################################
  programs.zsh = {
    enable                    = true;
    autosuggestion.enable     = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable  = true;
      theme   = "";
      plugins = [ "git" "docker" "kubectl" "terraform" ];
    };

    shellAliases = {
      ll   = "eza -alh --icons";
      gs   = "git status";
      ga   = "git add .";
      gc   = "git commit";
      gp   = "git push";
      nixr = "sudo nixos-rebuild switch --flake .#chaithu";
    };

    initContent = ''
      # Starship prompt
      eval "$(${pkgs.starship}/bin/starship init zsh)"
      # Better reverse-i-search
      bindkey '^R' history-incremental-search-backward
    '';
  };

  ########################################
  # Starship prompt
  ########################################
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      character  = { success_symbol = "[➜](bold green)"; error_symbol = "[✗](bold red)"; };
      git_branch = { symbol = "🌱 "; };
      kubernetes = { symbol = "⛵ "; disabled = false; };
      terraform  = { symbol = "💠 "; };
      aws        = { symbol = "☁️ "; };
    };
  };

  ########################################
  # Fonts & env
  ########################################
  fonts.fontconfig.enable = true;

  home.sessionVariables = {
    EDITOR = "vim";
    PAGER  = "less";
  };

  ########################################
  # One-time fixups on every switch
  ########################################
  home.activation = {
    fixCacheDir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ -d "$HOME/.cache/oh-my-zsh" ]; then
        chown -R "$USER:$USER" "$HOME/.cache/oh-my-zsh" || true
      fi
    '';
    stripCRLF = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
      if command -v dos2unix >/dev/null 2>&1; then
        dos2unix "$HOME/.zshrc" >/dev/null 2>&1 || true
      fi
    '';
  };

  ########################################
  # Home-Manager self-management
  ########################################
  programs.home-manager.enable = true;
}
