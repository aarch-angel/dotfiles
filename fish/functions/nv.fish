# Defined in - @ line 1
function nv --wraps=nvim --description 'Launch Neovide'
    neovide $argv &>/dev/null & disown
end
