# Setup fzf
# ---------
if [[ -d /opt/homebrew/opt/fzf/bin ]] && [[ ! "$PATH" == */opt/homebrew/opt/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/opt/homebrew/opt/fzf/bin"
elif [[ -d /home/linuxbrew/.linuxbrew/opt/fzf/bin ]] && [[ ! "$PATH" == */home/linuxbrew/.linuxbrew/opt/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/linuxbrew/.linuxbrew/opt/fzf/bin"
fi

if command -v fzf >/dev/null 2>&1; then
  source <(fzf --zsh)
fi
