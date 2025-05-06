{ config, pkgs, ... }:

{
  ##################################################
  # User & State
  ##################################################
  home.username      = "chaithu";
  home.homeDirectory = "/home/chaithu";
  home.stateVersion  = "24.11";

  ##################################################
  # Packages
  ##################################################
  home.packages = with pkgs; [
    neofetch
    xclip
    tmux              # tmux.nix will configure it
    tree
    zsh               # programs.zsh below
    dos2unix
    ghostty
    alacritty
    bat
    fzf
    eza               # replacement for exa
    ripgrep
    zoxide
    bottom
    starship          # programs.starship below

    # Nerd Fonts (now individual pkgs.nerd-fonts.<name>)
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
  };

  ##################################################
  # Starship Prompt Configuration
  ##################################################
  programs.starship = {
    enable   = true;
    settings = {
      add_newline = false;
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol   = "[✗](bold red)";
      };
      git_branch   = { symbol = "🌱 "; };
      kubernetes   = { symbol = "⛵ "; disabled = false; };
      terraform    = { symbol = "💠 "; };
      aws          = { symbol = "☁️  "; };
    };
  };

  ##################################################
  # Fonts & Environment Variables
  ##################################################
  fonts.fontconfig.enable = true;

  home.sessionVariables = {
    EDITOR = "vim";
    PAGER  = "less";
  };

  ##################################################
  # Home Manager Self-Management
  ##################################################
  programs.home-manager.enable = true;
}
