#!/usr/bin/env fish

# Copy files from /etc based on what exists in ./etc

set DOTFILES_ETC (test -n "$argv[1]"; and echo $argv[1]; or echo "./etc")

# Check if ./etc directory exists
if not test -d $DOTFILES_ETC
    echo "Error: $DOTFILES_ETC directory not found in current directory"
    exit 1
end

echo "Syncing files from /etc to $DOTFILES_ETC/"
echo ---

set -l copied_count 0
set -l failed_count 0

# Find all files (not directories) in ./etc
for local_file in (find $DOTFILES_ETC -type f)
    # Remove the ./etc prefix to get the relative path
    set rel_path (string replace -r "^$DOTFILES_ETC/?" "" $local_file)

    # Construct the source path in /etc
    set source_file "/etc/$rel_path"

    # Check if source file exists
    if test -f $source_file
        # Copy with preservation of permissions/timestamps
        if cp -p $source_file $local_file
            echo "✓ Copied: $source_file"
            set copied_count (math $copied_count + 1)
        else
            echo "✗ Failed: $source_file (permission denied?)"
            set failed_count (math $failed_count + 1)
        end
    else
        echo "⚠ Skipped: $source_file (doesn't exist in /etc)"
    end
end

echo ---
echo "Summary: $copied_count copied, $failed_count failed"

if test $failed_count -gt 0
    echo ""
    echo "Note: Some files may require sudo. Try: sudo $argv[0]"
end
