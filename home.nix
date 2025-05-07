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
    enableCompletion          = true;
    autosuggestion.enable     = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable  = true;
      theme   = "agnoster";
      plugins = [ "git" "kubectl" "terraform" ];
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
      # Starship prompt integration
      eval "$(starship init zsh)"
      # Optional: direnv hook
      if command -v direnv >/dev/null; then eval "$(direnv hook zsh)"; fi
    '';
  };
  ##################################################
  # Starship prompt
  ##################################################
  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      
      # Single line version with angular segments
      format = "$username$directory$git_branch$cmd_duration$time$character";
      
      username = {
        style_user = "bg:yellow fg:black";
        style_root = "bg:red fg:black";
        format = "[$user]($style)";
        show_always = true;
      };
      
      directory = {
        truncation_length = 3;
        style = "bg:blue fg:black";
        format = "[ $path ]($style)";
      };
      
      git_branch = {
        style = "bg:green fg:black";
        format = "[ $symbol$branch ]($style)";
        symbol = "󰊢 ";
      };
      
      cmd_duration = {
        style = "bg:cyan fg:black";
        format = "[ 󱦟 $duration ]($style)";
        min_time = 500;
      };
      
      time = {
        disabled = false;
        style = "bg:purple fg:black";
        format = "[ 󰥔 $time ]($style)";
        time_format = "%H:%M:%S";
      };
      
      character = {
        success_symbol = "[➜ ](bold green)";
        error_symbol = "[✗ ](bold red)";
      };
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
