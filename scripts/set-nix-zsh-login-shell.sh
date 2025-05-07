#!/usr/bin/env bash
set -euo pipefail

# Detect the Nix-profile Zsh path
PROFILE_ZSH="${HOME}/.nix-profile/bin/zsh"

# Add to /etc/shells if missing
if ! grep -Fxq "$PROFILE_ZSH" /etc/shells; then
  echo "Adding $PROFILE_ZSH to /etc/shells"
  echo "$PROFILE_ZSH" | sudo tee -a /etc/shells > /dev/null
fi

# Change login shell
echo "Changing login shell to $PROFILE_ZSH"
chsh -s "$PROFILE_ZSH" "$USER"

echo "Done. Please log out and log back in to start using Zsh."
