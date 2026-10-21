# Chinese input on GNOME Wayland

Configured on 2026-10-22 using Ubuntu's existing IBus desktop integration.

- Packages: `ibus-libpinyin` (1.16.5-6ubuntu1) and `fonts-noto-cjk`.
- Input sources: US English (`xkb`, `us`) and Intelligent Pinyin (`ibus`, `libpinyin`).
- Default remains English; desktop display language is unchanged.
- Switch sources with **Super + Space** (Super is the Windows key).
- Select Pinyin, type `nihao`, then press Space to select a candidate such as 你好.

IBus was restarted after installation, and `ibus list-engine` confirmed `libpinyin - Intelligent Pinyin`. The GNOME IBus user service was running. Typing inside a graphical application still needs a user check.

## Restore

From a terminal in the logged-in GNOME desktop session, as the normal user:

```bash
bash scripts/setup-chinese-ime.sh
```

The script installs the packages, preserves existing input sources, adds Pinyin if missing, and restarts IBus. Reopen applications if necessary. If the input source remains unavailable, log out and back in.

## Verify and customize

```bash
gsettings get org.gnome.desktop.input-sources sources
ibus list-engine | grep libpinyin
systemctl --user status org.freedesktop.IBus.session.GNOME.service
```

Manage sources in **Settings → Keyboard → Input Sources**. Pinyin preferences are available through:

```bash
/usr/libexec/ibus-setup-libpinyin libpinyin
```

## Remove the input source

Use Settings → Keyboard → Input Sources to remove Chinese (Intelligent Pinyin). Other keyboard sources and Chinese fonts can remain installed.

Reference: [Ubuntu keyboard input sources](https://help.ubuntu.com/stable/ubuntu-help/keyboard-layouts.html.en).
