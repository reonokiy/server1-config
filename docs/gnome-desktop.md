# Personal GNOME desktop extensions

Recorded on 2026-10-30 on Ubuntu 26.10, GNOME Shell 51.0, Wayland.
This is a selected desktop configuration, not a complete home-directory backup.

## Rounded windows

- Fork: <https://github.com/reonokiy/rounded-window-corners>
- Pinned revision: `22d10bc4038433aeb2c05f6b4242e3ddb0da5a7e`
- Upstream: <https://github.com/flexagoon/rounded-window-corners>
- UUID: `rounded-window-corners@fxgn`
- Installed location: `~/.local/share/gnome-shell/extensions/rounded-window-corners@fxgn`
- Declared Shell versions: 50 and 51. Global extension version validation remains enabled.
- Radius: 15 logical pixels; padding: 1 on each side; smoothing: 0; border width: 0.
- Libadwaita and Libhandy applications are included.
- Blacklist and custom window overrides are empty; whitelist mode is disabled.
- Maximized and fullscreen windows keep square corners and do not keep custom shadows.
- Focused shadow: x=0, y=4, blur=28, spread=4, opacity=60.
- Unfocused shadow: x=0, y=2, blur=12, spread=-1, opacity=65.

All saved values are in `config/gnome/desktop-settings.json`. The extension owns
`settings-version`; the restore script does not write that internal migration key.

### Verification status

TypeScript compilation, strict schema compilation, metadata formatting, and
translation compilation passed. The fork change only adds GNOME 51 to the
version declaration and points the project URL to the personal fork; no runtime
API adaptation has been established yet.

The files and login activation setting are installed. The current Shell session
does not know the new UUID, and its `ReloadExtension` method reports that it is
deprecated. Log out and log back in before checking whether the extension works.
Runtime loading and visual behavior on GNOME 51 are still unverified.

## Stable IBus candidates

`config/gnome/extensions/stable-ibus-candidates@local/` contains the installed
personal extension source and metadata. It forces horizontal candidates and
keeps the candidate popup anchored while visible. A new popup follows the cursor
again. It restores the original methods when disabled.

This extension declares GNOME 51 support and was confirmed enabled with an empty
error string through the current Shell session's extension interface.
It uses private GNOME IBus methods and needs checking after Shell upgrades.

The snapshot also records the current input sources, input switching shortcuts,
IBus panel orientation, and libpinyin preferences. Input sources currently include
US English, libpinyin, Cassotis, and Rime. Their engines are not installed by the
desktop restore script; install the desired engines separately before restoring.
The snapshot contains preferences, not dictionaries, typed text, or credentials.

## Restore

Review `config/gnome/desktop-settings.json` before applying it: it restores the
captured input source list and libpinyin preferences, including defaults.
Other enabled extensions are preserved.

Install prerequisites (a compatible Node.js/npm installation is also required):

```bash
sudo apt-get install git gettext libglib2.0-bin python3-gi ibus-libpinyin
```

Run from this repository in the logged-in desktop session, without sudo:

```bash
bash scripts/setup-gnome-desktop.sh
```

This builds the pinned fork with locked npm dependencies, installs translations
and schemas, installs both extensions, validates and restores preferences, and
adds both UUIDs to the login activation list. It does not restart GNOME or log
you out. Existing extension files and affected preferences are backed up under
`${XDG_DATA_HOME:-~/.local/share}/server1-config/backups/`.

If both extensions are already installed, validate the snapshot without writing:

```bash
/usr/bin/python3 scripts/restore-gnome-desktop.py --check
```

Apply preferences and the tracked IBus extension without rebuilding the rounded
extension:

```bash
/usr/bin/python3 scripts/restore-gnome-desktop.py
```

## Check after logging back in

```bash
gnome-extensions info rounded-window-corners@fxgn
gnome-extensions info stable-ibus-candidates@local
gnome-extensions prefs rounded-window-corners@fxgn
journalctl --user -b _COMM=gnome-shell --no-pager | tail -n 100
```

Check normal windows, maximizing, fullscreen, tiling, overview, workspace
switching, and suspend/resume. Confirm candidate orientation and anchoring by
typing in an application.

To disable either extension:

```bash
gnome-extensions disable rounded-window-corners@fxgn
gnome-extensions disable stable-ibus-candidates@local
```
