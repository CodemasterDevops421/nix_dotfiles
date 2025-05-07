#!/usr/bin/env bash
set -euo pipefail

# Create an empty ~/.zshenv and ~/.zprofile so zsh-newuser-install won't trigger
touch "$HOME/.zshenv" "$HOME/.zprofile"

# Write a minimal ~/.zshrc that sources your Home Manager session vars
cat > "$HOME/.zshrc" << 'EOF'
# Prevent zsh-newuser-install from running
# and load Home Manager environment:
if [ -f "${HOME}/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then
  source "${HOME}/.nix-profile/etc/profile.d/hm-session-vars.sh"
fi

# Load Oh My Zsh from Home Manager
if [ -d "${HOME}/.nix-profile/share/oh-my-zsh" ]; then
  export ZSH="${HOME}/.nix-profile/share/oh-my-zsh"
  source "${ZSH}/oh-my-zsh.sh"
fi

# Load Starship prompt if enabled
if command -v starship &> /dev/null; then
  eval "$(starship init zsh)"
fi
EOF

echo "✅ ~/.zshrc initialized. Please exit and re-open your terminal."
