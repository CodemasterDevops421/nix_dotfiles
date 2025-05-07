# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# =============================
# ZSH CONFIGURATION (WSL/DEV)
# =============================

# Use Powerlevel10k theme
source ~/powerlevel10k/powerlevel10k.zsh-theme
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# Enable ZSH Plugins
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Autosuggestions color
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

# Enable completion system
autoload -Uz compinit && compinit

# PATH updates
export PATH=$PATH:$HOME/.local/bin:$HOME/bin

# Vagrant configuration (for WSL2)
export VAGRANT_DEFAULT_PROVIDER='hyperv'
export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS="1"

# Fix WSL2 interop
fix_wsl2_interop() {
  for i in $(ps -e | grep -o '[0-9]*'); do
    if [[ -e "/run/WSL/${i}_interop" ]]; then
      export WSL_INTEROP="/run/WSL/${i}_interop"
      break
    fi
  done
}
fix_wsl2_interop

# Zsh history settings
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY

# Prompt fallback (in case p10k fails)
PROMPT='%F{cyan}%n@%m%f:%F{yellow}%~%f$ '

# Aliases
[[ ! -f /bin/exa ]] && echo "Warning: exa is not installed" || alias ls='exa --icons --group-directories-first'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m'
alias gp='git push'
alias gl='git pull'
alias zrc='nano ~/.zshrc'
alias reload='source ~/.zshrc'
alias cls='clear'

# Editor preference
export EDITOR=nano

# Disable bell
setopt NO_BEEP

# =============================
# END OF CONFIGURATION
# =============================
