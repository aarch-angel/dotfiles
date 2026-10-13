# Maya's Dotfiles



https://github.com/user-attachments/assets/a80ab74c-3240-4563-8cd4-19861e5292a2



- **OS**: [Arch Linux](https://archlinux.org/)
- **Desktop Environment**: [KDE Plasma](https://kde.org/plasma-desktop/) ([Breeze Dark](https://github.com/KDE/breeze))
  - [Krohnkite](https://codeberg.org/anametologin/Krohnkite) for tiling
  - [KDE Rounded Corners](https://github.com/matinlotfali/KDE-Rounded-Corners)
  - [Kwin Better Blur DX](https://github.com/xarblu/kwin-effects-better-blur-dx)
- **Font**: [Iosevka](https://typeof.net/Iosevka/)
- **Terminal:** [WezTerm](https://wezterm.org/)
- **Shell:** [Fish](https://fishshell.com/) with [Fisher](https://github.com/jorgebucaran/fisher) for plugins and [Starship](https://starship.rs/) for the prompt.
- **Editor:** [Neovim](https://neovim.io/) with [LazyVim](https://www.lazyvim.org/), mainly used through [Neovide](https://neovide.dev/).
- **Command-line tools:** [`eza`](https://github.com/eza-community/eza), [`bat`](https://github.com/sharkdp/bat), [`fzf`](https://github.com/junegunn/fzf), [`ripgrep`](https://github.com/BurntSushi/ripgrep), [`fd`](https://github.com/sharkdp/fd), [`btop`](https://github.com/aristocratos/btop), [`yazi`](https://yazi-rs.github.io/), [`navi`](https://github.com/denisidoro/navi)
- **Terminal & Neovim Theme**: [Horizon Dark (Gogh)](https://horizontheme.netlify.app)

## Installation with Dotbot

Clone the repository and its [Dotbot](https://github.com/anishathalye/dotbot) submodule, then run [`install`](install):

```sh
git clone --recurse-submodules <repo-url>
cd Dotfiles
./install
```

If already cloned without submodules, `./install` initializes the Dotbot submodule before applying [`install.conf.yaml`](install.conf.yaml).

Dotbot is configured to link files from [`home/`](home/) into hidden files in the home directory, and links items from [`config/`](config/), [`fish/`](fish/), [`nvim/`](nvim/), and [`resources/boxes/`](resources/boxes/) into their corresponding locations under `~/.config`.

It also runs [`scripts/copy_etc.fish`](scripts/copy_etc.fish), which copies matching files from the live `/etc` tree into the repository's [`etc/`](etc/) tree to track system configuration.

## Repository layout

- [`config/`](config/): application settings, including WezTerm, Yazi, Starship, and other tools
- [`fish/`](fish/): Fish configuration, functions, theme, and plugin list
- [`nvim/`](nvim/): LazyVim configuration
- [`home/`](home/): files linked into the home directory, such as Git and GDB settings
- [`etc/`](etc/): system configuration files
- [`machines/`](machines/): host-specific system and boot configuration, keyed by hostname
- [`scripts/`](scripts/): helper scripts for system-file syncing and other tasks
- [`resources/`](resources/): themes, images, and assets used by the configs
- [`dotbot/`](dotbot/): Dotbot, included as a Git submodule
