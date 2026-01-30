#!/bin/bash

# Fast Key Repeat (Essential for coding)
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Finder: Show path bar and status bar
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true

# Finder: Show all file extensions (Critical for devs)
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Dock: Automatically hide and show
defaults write com.apple.dock autohide -bool true

# Restart Finder and Dock to apply
killall Finder
killall Dock
