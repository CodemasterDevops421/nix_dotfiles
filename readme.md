"# wsl-home Configuration

This repository contains your Nix flake-based Home Manager setup for WSL Ubuntu, providing:

* Zsh with Oh My Zsh, autosuggestions, syntax highlighting
* Starship prompt configuration
* Handy packages: tmux, neovim, fzf, ripgrep, and more
* Neovim and tmux modules

---

## Repository Structure

```
.
└── wsl-home
    ├── flake.lock
    ├── flake.nix
    ├── home.nix      ← core Home Manager config
    ├── neovim.nix    ← Neovim settings
    ├── tmux.nix      ← tmux settings
    ├── p10k.zsh      ← (optional Powerlevel10k)
    └── readme.md     ← this file
```

**Note:** Make sure your WSL Ubuntu user is named `chaithu`, or update `home.username` and `home.homeDirectory` in `home.nix` accordingly.

---

## Prerequisites

On a fresh WSL Ubuntu (x86\_64) instance, install and enable Nix with flakes:

1. **Open PowerShell (Admin) and install WSL Ubuntu:**

   ```powershell
   wsl --install -d Ubuntu
   ```
2. **Update system and install essentials:**

   ```bash
   sudo apt update && sudo apt upgrade -y
   sudo apt install -y curl git build-essential
   ```
3. **Install Nix (multi-user) and enable flakes:**

   ```bash
   curl -L https://nixos.org/nix/install | sh
   source ~/.nix-profile/etc/profile.d/nix.sh

   mkdir -p ~/.config/nix
   cat <<EOF > ~/.config/nix/nix.conf
   experimental-features = nix-command flakes
   EOF
   ```

---

## Applying Your Dotfiles

1. **Clone this repo:**

   ```bash
   cd ~
   git clone https://github.com/your-username/wsl-home.git
   cd wsl-home
   ```
2. **Normalize line endings (optional):**

   ```bash
   git config --global core.autocrlf false
   find . -type f \( -name '*.nix' -o -name '*.zsh' \) -exec dos2unix {} +
   ```
3. **Switch Home Manager:**

   ```bash
   home-manager switch --flake .#chaithu
   ```
4. **Restart your shell:**

   ```bash
   exec zsh
   ```

After these steps, you’ll have a fully configured Zsh, Starship prompt, Neovim, tmux, and all packages from your Home Manager flake.

---

## Troubleshooting

* **`^M` characters on paste or in `.zshrc`:**

  ```bash
  dos2unix ~/.config/home-manager/home.nix
  home-manager switch --flake .#chaithu
  dos2unix ~/.zshrc
  exec zsh
  ```

* **Ensure LF-only endings in Git:** Add a `.gitattributes`:

  ```gitattributes
  * text=auto eol=lf
  *.nix text eol=lf
  *.zsh text eol=lf
  ```

  ```bash
  git add .gitattributes
  git commit -m "normalize line endings to LF"
  git push
  ```

With these in place, fresh clones on WSL (or any OS) will use LF and avoid CRLF issues."
