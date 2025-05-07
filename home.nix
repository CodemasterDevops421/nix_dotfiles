{ config, pkgs, lib, ... }:

{
  ##################################################
  # Basic user info
  ##################################################
  home.username      = "chaithu";
  home.homeDirectory = "/home/chaithu";
  home.stateVersion  = "24.11";

  ##################################################
  # Packages (apps + fonts)
  ##################################################
  home.packages = with pkgs; [
    neofetch xclip tmux tree zsh dos2unix ghostty alacritty
    bat fzf eza ripgrep zoxide bottom starship sqlite
    zsh-histdb
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.hack
  ];

  ##################################################
  # Z-shell configuration
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

    initContent = ''
      # histdb plugin
      fpath=(${pkgs.zsh-histdb}/share/zsh/site-functions $fpath)
      autoload -Uz histdb histdb-top _histdb-isearch
      bindkey '^R' _histdb-isearch

      # Starship prompt
      eval "$(${pkgs.starship}/bin/starship init zsh)"
    '';
  };

  ##################################################
  # Starship prompt
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
  # Fonts & session variables
  ##################################################
  fonts.fontconfig.enable = true;

  home.sessionVariables = {
    EDITOR = "vim";
    PAGER  = "less";
  };

  ##################################################
  # Home-Manager self-management
  ##################################################
  programs.home-manager.enable = true;
}
