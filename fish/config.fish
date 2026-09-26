# NOTE: conf.d/___custom_init.fish executes before any plugins are loaded, this config executes after

# fish config
fish_add_path -g ~/.local/bin ~/.local/share/pnpm/bin ~/.cargo/bin
set -g fish_key_bindings fish_vi_key_bindings
fish_config theme choose horizon

# curretly using forks of plugin_grc

set -gx DIFFPROG "nvim -d"
set -gx EDITOR nvim

# Rootless Docker
set -gx DOCKER_HOST unix://$XDG_RUNTIME_DIR/docker.sock

# bat-extras
# batman to replace man
export MANPAGER=env\ BATMAN_IS_BEING_MANPAGER=yes\ bash\ /usr/bin/batman
export MANROFFOPT=-c

set -gx SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/ssh-agent.socket"

# Coloured stuffs?
# this is handled by the fish grc plugin
# source /etc/grc.fish
# NOTE: add execptions to grc in ___custom_init.fish

# pnpm
set -gx PNPM_HOME "$HOME/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

# To fix issuse with finding the Zephyr SDK
set -gx ZEPHYR_TOOLCHAIN_VARIANT zephyr

# I don't wanna deal with this breaking rn
set async_prompt_enable 0

starship init fish | source
navi widget fish | source
# mise activate fish | source
