
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/kyleschmidt/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/kyleschmidt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/kyleschmidt/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/kyleschmidt/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

export PATH=~/.npm-global/bin:$PATH
