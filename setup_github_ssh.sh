#!/bin/bash

# Prompt for GitHub email
read -p "Enter your GitHub email: " email

# Generate SSH key
echo "Generating SSH key..."
ssh-keygen -t ed25519 -C "$email" -f ~/.ssh/id_ed25519 -N ""

# Start SSH agent
echo "Starting ssh-agent..."
eval "$(ssh-agent -s)"

# Add SSH key to agent
ssh-add ~/.ssh/id_ed25519

# Print public key
echo -e "\n✅ Public SSH key (copy this and add it to GitHub → Settings → SSH and GPG Keys):\n"
cat ~/.ssh/id_ed25519.pub

# Guide for GitHub SSH setup
echo -e "\n📎 Open this link to add your key to GitHub:"
echo "👉 https://github.com/settings/keys"
echo -e "\nAfter adding the key, press ENTER to continue."
read

# Set Git remote to SSH
git remote set-url origin git@github.com:CodemasterDevops421/nix_dotfiles.git
# Push to main branch
git push -u origin main

echo -e "\n🚀 Done! You're now using SSH with GitHub."
