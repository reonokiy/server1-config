#!/usr/bin/env bash
set -euo pipefail
if (( EUID == 0 )); then
    echo 'Run as your desktop user; package installation uses sudo.' >&2
    exit 1
fi
repo_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
sudo apt-get install -y fontconfig fonts-noto-core fonts-noto-cjk fonts-dejavu-core
font_config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/fontconfig/conf.d"
mkdir -p "$font_config_dir"
source_file="$repo_root/config/fontconfig/conf.d/60-english-chinese.conf"
target_file="$font_config_dir/60-english-chinese.conf"
if [[ -f "$target_file" ]] && ! cmp -s "$source_file" "$target_file"; then
    cp -p "$target_file" "$target_file.backup.$(date +%Y%m%d%H%M%S)"
fi
install -m 644 "$source_file" "$target_file"
fc-cache -f
for family in sans-serif serif monospace; do
    printf '%s English: ' "$family"
    fc-match -f '%{family}\n' "$family:lang=en:charset=41"
    printf '%s Chinese: ' "$family"
    fc-match -f '%{family}\n' "$family:lang=zh-cn:charset=4e2d"
done
