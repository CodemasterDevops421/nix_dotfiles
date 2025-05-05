# Getting Started

```sh
nix shell nixpkgs#home-manager nixpkgs#gh --command sh -c " \
  gh auth login \
  && gh repo clone nixchaithu/wsl-home -- --depth=1 \
  && home-manager switch --flake ./wsl-home#nixchaithu \
"
```
