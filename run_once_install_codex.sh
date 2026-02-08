#!/bin/bash

# Check if npm is installed
if command -v npm >/dev/null 2>&1; then
    # Install OpenAI Codex globally if not present
    if ! command -v codex >/dev/null 2>&1; then
        echo "Installing OpenAI Codex..."
        npm install -g @openai/codex
    else
        echo "OpenAI Codex is already installed."
    fi
else
    echo "Error: npm is not installed. Skipping OpenAI Codex."
fi
