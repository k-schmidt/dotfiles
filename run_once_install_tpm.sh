#!/bin/sh

# Ensure the directory exists
mkdir -p ~/.tmux/plugins

# Clone TPM if it doesn't already exist
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    echo "Installing Tmux Plugin Manager..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi