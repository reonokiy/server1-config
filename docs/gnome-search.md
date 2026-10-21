# GNOME app search

Alt + Space opens GNOME's Activities overview. Start typing an app name and press Enter to launch it. Escape closes the overview. The existing Super-key shortcut remains available.

Configured on 2026-10-22 for Ubuntu GNOME on Wayland. No extra launcher is required.

## Restore

Run as the logged-in desktop user, without sudo:

```bash
bash scripts/setup-gnome-search.sh
```

The script removes Alt + Space from the window-menu binding and adds it to `org.gnome.shell.keybindings toggle-overview`, preserving other entries.

## Verify

```bash
gsettings get org.gnome.shell.keybindings toggle-overview
gsettings get org.gnome.desktop.wm.keybindings activate-window-menu
```

The settings were read back successfully after applying. Verify the actual shortcut interactively on the desktop.

## Restore this machine's original bindings

Original values were an empty overview shortcut list and Alt + Space for the window menu:

```bash
gsettings set org.gnome.shell.keybindings toggle-overview '[]'
gsettings set org.gnome.desktop.wm.keybindings activate-window-menu "['<Alt>space']"
```
