#!/usr/bin/env bash
set -euo pipefail
# Run as the logged-in desktop user.
if (( EUID == 0 )); then
    echo 'Run this as your desktop user, without sudo.' >&2
    exit 1
fi
# Remove only the conflicting binding, preserving other configured shortcuts.
/usr/bin/python3 - <<'PY'
from gi.repository import Gio, GLib
window = Gio.Settings.new('org.gnome.desktop.wm.keybindings')
shell = Gio.Settings.new('org.gnome.shell.keybindings')
window.set_strv('activate-window-menu', [key for key in window.get_strv('activate-window-menu') if key.lower() != '<alt>space'])
keys = list(shell.get_strv('toggle-overview'))
if not any(key.lower() == '<alt>space' for key in keys):
    keys.append('<Alt>space')
shell.set_strv('toggle-overview', keys)
Gio.Settings.sync()
PY
printf '%s\n' 'Alt+Space opens GNOME overview. Type an app name and press Enter.'
