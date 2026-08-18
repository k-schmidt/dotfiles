#!/bin/sh

# run_after_, not run_once_. chezmoi records a run_once_ script as done the
# moment it exits, success or not -- so the one time this clone failed it was
# never retried, and tmux sat there with no plugins and a status bar full of
# unexpanded #{...} tokens. The body below is already a no-op when everything
# is present, so re-checking on every apply costs one stat call and buys an
# automatic retry.
#
# after_, so ~/.gitconfig is on disk first: on a Meta-managed laptop its
# [http "https://github.com"] block carries the proxy and client cert that
# make this clone possible at all.

# Ensure the directory exists
mkdir -p ~/.tmux/plugins

# Clone TPM if it doesn't already exist
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    echo "Installing Tmux Plugin Manager..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm || echo "Skipping TPM install (github.com unreachable)"
fi