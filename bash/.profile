# ~/.profile: executed by the command interpreter for login shells.

if [ -n "$BASH_VERSION" ] && [ -f "$HOME/.bashrc" ]; then
  source "$HOME/.bashrc"
else
  printf '%s\n' \
    "ERROR: Login shell must be bash with ~/.bashrc present." \
    "  BASH_VERSION=${BASH_VERSION:-<unset>}" \
    "  bashrc=$([ -f "$HOME/.bashrc" ] && echo ok || echo missing)" \
    >&2
  exit 1
fi


