#!/usr/bin/env fish

# Function to check if KWin's global shortcuts component is accessible
function check_kwin_shortcuts
    if not qdbus6 org.kde.kglobalaccel /component/kwin >/dev/null 2>&1
        echo "Error: Cannot access KWin's global shortcuts component"
        exit 1
    end
end

# Function to validate if a shortcut exists
function validate_shortcut
    set -l shortcut $argv[1]
    set -l shortcuts (qdbus6 org.kde.kglobalaccel /component/kwin org.kde.kglobalaccel.Component.shortcutNames)

    if not contains -- "$shortcut" $shortcuts
        echo "Error: Shortcut '$shortcut' is not found"
        echo "Available shortcuts:"
        printf "%s\n" $shortcuts
        exit 1
    end
end

# Function to trigger a KWin shortcut
function trigger_shortcut
    set -l shortcut $argv[1]
    qdbus6 org.kde.kglobalaccel /component/kwin org.kde.kglobalaccel.Component.invokeShortcut "$shortcut"

    # Add a small delay between shortcuts
    sleep 0.1
end

# Function to list all available shortcuts
function list_shortcuts
    echo "Available KWin shortcuts:"
    qdbus6 org.kde.kglobalaccel /component/kwin org.kde.kglobalaccel.Component.shortcutNames
end

# Main function
function main
    # Check if any arguments were provided
    if test (count $argv) -eq 0
        echo "Error: No shortcuts specified"
        echo "Usage: "(status filename)" [--list] <shortcut1> <shortcut2> ..."
        echo "Example: "(status filename)" 'Switch to Next Screen' MoveMouseToFocus"
        exit 1
    end

    # Check if KWin shortcuts are accessible
    check_kwin_shortcuts

    # Validate all shortcuts first
    for shortcut in $argv
        validate_shortcut "$shortcut"
    end

    # Execute all shortcuts in sequence
    for shortcut in $argv
        echo "Executing: $shortcut"
        trigger_shortcut "$shortcut"
    end

    echo "Shortcuts executed successfully"
end

# If --list argument is provided, show available shortcuts instead of executing
if test "$argv[1]" = --list
    list_shortcuts
    exit 0
end

main $argv
