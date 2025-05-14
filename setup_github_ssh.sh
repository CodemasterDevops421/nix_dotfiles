#!/usr/bin/env bash

# Prompt for GitHub email and repository (e.g. user/repo.git)
read -rp "Enter your GitHub email: " email
read -rp "Enter GitHub repo (user/repo.git): " repo

# Generate SSH key
echo "Generating SSH key..."
ssh-keygen -t ed25519 -C "$email" -f ~/.ssh/id_ed25519 -N ""

# Start SSH agent
echo "Starting ssh-agent..."
eval "$(ssh-agent -s)"

# Add SSH key to agent
ssh-add ~/.ssh/id_ed25519

# Show public key
echo -e "\n✅ Public SSH key (copy to GitHub → Settings → SSH and GPG keys):\n"
cat ~/.ssh/id_ed25519.pub
echo -e "\nPress ENTER after adding the key."
read -r

# Set Git remote using provided repo
git remote set-url origin "git@github.com:${repo}"
git push -u origin main

echo -e "\n🚀 Done! You're now using SSH with GitHub."
