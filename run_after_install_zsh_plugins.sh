#!/bin/bash

# run_after_, not run_once_. See run_after_install_tpm.sh for the reasoning:
# a run_once_ script that fails is still marked done and never retried, so a
# single flaky network call would leave oh-my-zsh permanently missing. Every
# step below is guarded by a directory check, so a re-run is four stat calls
# when nothing is missing, and a failed clone gets another attempt on every
# apply instead of exactly one, forever.
# 1. Install Oh My Zsh (unattended) if it's missing
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended || echo "Skipping Oh My Zsh install (github.com unreachable)"
fi

# Define the custom directory (defaults to OMZ custom)
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

# 2. Install Powerlevel10k Theme
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
  echo "Installing Powerlevel10k..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k" || echo "Skipping Powerlevel10k install (github.com unreachable)"
fi

# 3. Install Zsh Autosuggestions
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  echo "Installing zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions" || echo "Skipping zsh-autosuggestions install (github.com unreachable)"
fi

# 4. Install Zsh Syntax Highlighting
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  echo "Installing zsh-syntax-highlighting..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" || echo "Skipping zsh-syntax-highlighting install (github.com unreachable)"
fi
