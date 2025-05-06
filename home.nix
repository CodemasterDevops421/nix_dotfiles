{ config, pkgs, ... }:

{
  ##################################################
  # Basic user info
  ##################################################
  home.username      = "chaithu";
  home.homeDirectory = "/home/chaithu";
  home.stateVersion  = "24.11";

  ##################################################
  # Packages
  ##################################################
  home.packages = with pkgs; [
    neofetch  xclip   tmux    tree   zsh   dos2unix  ghostty  alacritty
    bat       fzf     eza     ripgrep zoxide bottom  starship sqlite
    zsh-histdb                             # history‑to‑SQLite plugin
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
  ];

  ##################################################
  # Zsh Configuration
  ##################################################
  programs.zsh = {
    enable                    = true;
    autosuggestion.enable     = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable  = true;
      theme   = "agnoster";
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

    initExtra = ''
      # histdb plugin
      fpath=(${pkgs.zsh-histdb}/share/zsh/site-functions $fpath)
      autoload -Uz histdb histdb-top _histdb-isearch
      histdb-install || true
      bindkey '^R' _histdb-isearch
    '';
  };

  ##################################################
  # Starship Prompt
  ##################################################
  programs.starship = {
    enable   = true;
    settings = {
      add_newline = false;

      character = {
        success_symbol = "[➜](bold green)";
        error_symbol   = "[✗](bold red)";
      };

      git_branch = { symbol = "🌱 "; };
      kubernetes = { symbol = "⛵ "; disabled = false; };
      terraform  = { symbol = "💠 "; };
      aws        = { symbol = "☁️  "; };
    };
  };

  ##################################################
  # Fonts & Session Variables
  ##################################################
  fonts.fontconfig.enable = true;

  home.sessionVariables = {
    EDITOR = "vim";
    PAGER  = "less";
  };

  ##################################################
  # Home-Manager Self-Management
  ##################################################
  programs.home-manager.enable = true;
}
