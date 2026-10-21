#!/usr/bin/env bash
set -euo pipefail
# Run as the desktop user, inside the GNOME session.
if (( EUID == 0 )); then
    echo 'Run this as your desktop user; only package installation uses sudo.' >&2
    exit 1
fi
repo_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
mapfile -t packages < "$repo_root/config/ime/packages.txt"
sudo apt-get install -y "${packages[@]}"
# Preserve existing keyboards and add Pinyin only when absent.
python3 - <<'PY'
from gi.repository import Gio
settings = Gio.Settings.new('org.gnome.desktop.input-sources')
sources = list(settings.get_value('sources').unpack())
if ('ibus', 'libpinyin') not in sources:
    sources.append(('ibus', 'libpinyin'))
    from gi.repository import GLib
    settings.set_value('sources', GLib.Variant('a(ss)', sources))
    Gio.Settings.sync()
PY
ibus restart
printf '%s\n' 'Pinyin configured. Switch with Super+Space. If missing, log out and back in.'
