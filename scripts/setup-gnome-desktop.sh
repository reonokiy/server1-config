#!/usr/bin/env bash
set -euo pipefail
# Run as the logged-in desktop user; install prerequisites separately.
if (( EUID == 0 )); then
    echo 'Run this as your desktop user, without sudo.' >&2
    exit 1
fi
repo_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
source "$repo_root/config/gnome/rounded-window-corners.env"
for tool in git npm node msgfmt glib-compile-schemas gnome-shell; do
    command -v "$tool" >/dev/null || {
        echo "Missing dependency: $tool. See docs/gnome-desktop.md." >&2
        exit 1
    }
done
/usr/bin/python3 -c 'from gi.repository import Gio, GLib'
shell_version=$(gnome-shell --version)
if [[ ! "$shell_version" =~ Shell\ (50|51)(\.|$) ]]; then
    echo "This pinned extension only declares GNOME 50/51 support: $shell_version" >&2
    exit 1
fi
build_root=$(mktemp -d)
trap 'rm -rf -- "$build_root"' EXIT
git clone --quiet --no-checkout "$RWC_REPOSITORY" "$build_root/source"
git -C "$build_root/source" checkout --quiet --detach "$RWC_REVISION"
(
    cd "$build_root/source"
    npm ci --ignore-scripts
    ./node_modules/.bin/tsc --outDir _build
    cp -a resources/. _build/
    /usr/bin/python3 - <<'PY'
from pathlib import Path
import shutil
for source in Path('src').rglob('*'):
    if source.is_file() and source.suffix != '.ts':
        target = Path('_build') / source.relative_to('src')
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(source, target)
PY
    for translation in po/*.po; do
        locale=${translation##*/}
        locale=${locale%.po}
        target="_build/locale/$locale/LC_MESSAGES"
        mkdir -p "$target"
        msgfmt -o "$target/$RWC_UUID.mo" "$translation"
    done
    glib-compile-schemas --strict _build/schemas
)
/usr/bin/python3 "$repo_root/scripts/restore-gnome-desktop.py" \
    --install-rounded "$build_root/source/_build"
printf '%s\n' 'Desktop settings saved. Log out and back in to load newly installed extensions.'
