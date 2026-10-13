# Global Claude Instructions

## System

- OS: Arch Linux
- Shell: fish
- Editor: Neovim (LazyVim preset)
- Package manager: pacman / AUR (paru)

## Preferred CLI Tools

Always use these over standard alternatives:

- `eza` instead of `ls`
- `rg` (ripgrep) instead of `grep`
- `fd` instead of `find`
- `bat` instead of `cat` (when showing files to user)
- `fzf` available

- Bash tool runs bash, not fish (fish is only my interactive shell): write bash syntax in tool commands (`$(...)`, `for x in ...; do ...; done`, `<(...)`, heredocs), and only give fish syntax when suggesting commands for me to run myself.

## Communication

- Add inline comments to code.
- Bullet points are preferred over prose for long answers

## Preferences

- Tabs preferred for indentation, but default to project setup or idiomatic language formatting.
- dotfiles located in `~/Dotfiles/` in case configs are needed for reference
- Neovim config via LazyVim — suggest nvim-compatible tooling where relevant
- Always use Context7 when I need library/API documentation, code generation, setup or configuration steps without me having to explicitly ask.
