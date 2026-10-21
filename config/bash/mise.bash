# Source this from ~/.bashrc after adding ~/.local/bin to PATH.
if [ -x "$HOME/.local/bin/mise" ]; then
    eval "$("$HOME/.local/bin/mise" activate bash)"
fi
