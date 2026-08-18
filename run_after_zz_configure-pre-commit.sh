#!/bin/bash

set -u

if ! command -v pre-commit >/dev/null 2>&1; then
	echo "pre-commit not found. Skipping hook installation."
	exit 0
fi

source_repository="$(chezmoi source-path)"
if ! git -C "$source_repository" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
	echo "Chezmoi source is not a Git repository. Skipping pre-commit hook installation."
	exit 0
fi

echo "Installing the dotfiles pre-commit hook..."
(
	cd "$source_repository" || exit 1
	pre-commit install
)
