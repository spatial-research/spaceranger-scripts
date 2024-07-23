#!/bin/bash

# Define the directory where the scripts are located
SCRIPT_DIR="$(dirname "$(realpath "$0")")/scripts"

# The initialization code to be added to the shell configuration file
INIT_CODE="
# >>> spaceranger-scripts >>>
# !! Contents within this block was by 'init.sh' from spaceranger-scripts !!
export PATH=\"\$PATH:$SCRIPT_DIR\"
# <<< spaceranger-scripts <<<
"

# Add initialization code to a file if it doesn't already exist
add_init_code() {
    local FILE=$1
    if [ -f "$FILE" ]; then
        if grep -Fxq "$INIT_CODE" "$FILE"; then
            echo "Initialization code already exists in $FILE"
        else
            echo "Adding initialization code to $FILE"
            echo "$INIT_CODE" >> "$FILE"
        fi
    else
        echo "$FILE does not exist, creating and adding initialization code"
        echo "$INIT_CODE" > "$FILE"
    fi
}

# Add the initialization code to .bashrc
add_init_code "$HOME/.bashrc"

# Add the initialization code to .zshrc (if using zsh)
if [ -n "$ZSH_VERSION" ]; then
    add_init_code "$HOME/.zshrc"
fi

# Reload the shell configuration file to apply changes
if [ -n "$BASH_VERSION" ]; then
    source "$HOME/.bashrc"
elif [ -n "$ZSH_VERSION" ]; then
    source "$HOME/.zshrc"
fi

echo "Initialization completed. Please restart your terminal or run 'source ~/.bashrc' or 'source ~/.zshrc' to apply changes."