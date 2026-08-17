# Setup fzf
# ---------
if [[ -d /opt/homebrew/opt/fzf/bin ]] && [[ ! "$PATH" == */opt/homebrew/opt/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/opt/homebrew/opt/fzf/bin"
elif [[ -d /home/linuxbrew/.linuxbrew/opt/fzf/bin ]] && [[ ! "$PATH" == */home/linuxbrew/.linuxbrew/opt/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/linuxbrew/.linuxbrew/opt/fzf/bin"
fi

# `fzf --bash` only exists from 0.48 onward. The dnf build on the devserver
# predates it, and an unguarded call prints "unknown option" on every prompt,
# so fall back to the shell scripts the older package ships separately.
if command -v fzf >/dev/null 2>&1; then
  if _fzf_init="$(fzf --bash 2>/dev/null)"; then
    eval "$_fzf_init"
  else
    for _fzf_f in /usr/share/fzf/shell/key-bindings.bash \
                  /usr/share/fzf/shell/completion.bash; do
      [ -r "$_fzf_f" ] && source "$_fzf_f"
    done
  fi
  unset _fzf_init _fzf_f
fi
