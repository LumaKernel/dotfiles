return
echo ".bash_profile:$COLUMNS:$LINES:$BASH_SOURCE:$PATH" >> ~/.log
if [ -f "${HOME}/.bashrc" ]; then
  source "${HOME}/.bashrc"
fi

