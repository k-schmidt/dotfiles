#!/bin/bash

# Check if npm is installed
if command -v npm >/dev/null 2>&1; then
    # Install Claude Code globally if not present
    if ! command -v claude >/dev/null 2>&1; then
        echo "Installing Claude Code..."
        npm install -g @anthropic-ai/claude-code
    else
        echo "Claude Code is already installed."
    fi
else
    echo "Error: npm is not installed. Skipping Claude Code."
fi
