#!/bin/bash

# Unload if it exists (to refresh changes)
if launchctl list | grep -q com.local.KeyRemapping; then
    launchctl unload ~/Library/LaunchAgents/com.local.KeyRemapping.plist
fi

# Load it
launchctl load ~/Library/LaunchAgents/com.local.KeyRemapping.plist
echo "Caps Lock remapped to Control via LaunchAgent."
