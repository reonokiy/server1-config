# server1-config

Selected configuration and setup notes for `nokiy-server1`.

## Machine

- Gigabyte X870M AORUS ELITE WIFI7, BIOS F9
- AMD Ryzen 9 9950X, 16 cores / 32 threads
- Approximately 60 GiB usable RAM
- ZHITAI TiPlus7100s 4 TB NVMe
- Ubuntu 26.10; kernel at setup: `7.3.0-9-generic`

## Tracked configuration

| File | Installed destination |
| --- | --- |
| `config/fontconfig/conf.d/60-english-chinese.conf` | `~/.config/fontconfig/conf.d/60-english-chinese.conf` |
| `config/mise/config.toml` | `~/.config/mise/config.toml` |
| `config/bash/mise.bash` | Bash activation snippet; see setup notes |
| `config/gnome/desktop-settings.json` | Selected GSettings values; restore with the desktop setup script |
| `config/gnome/rounded-window-corners.env` | Pinned personal rounded-corners fork and revision |
| `config/gnome/extensions/stable-ibus-candidates@local/` | `~/.local/share/gnome-shell/extensions/stable-ibus-candidates@local/` |
| `etc/modules-load.d/it87.conf` | `/etc/modules-load.d/it87.conf` |
| `etc/sensors.d/gigabyte-it87.conf` | `/etc/sensors.d/gigabyte-it87.conf` |

- [Mise and GitHub CLI setup](docs/user-tools.md)
- [IT8696 fan monitoring fix and recovery](docs/fan-driver.md)
- [English and Chinese font rendering](docs/fonts.md)
- [GNOME app search shortcut](docs/gnome-search.md)
- [Chinese Pinyin input setup](docs/chinese-ime.md)
- [GNOME rounded windows, stable input candidates, and desktop restore](docs/gnome-desktop.md)
- [Initial performance screening](docs/performance.md)
- [macOS RDP connection hang — investigation paused](docs/rdp-troubleshooting.md)

Review files before installing them; this repository does not automatically apply configuration. Credentials, GitHub authentication state, private keys, and complete home-directory snapshots are excluded. GitHub authentication stays in the system keyring.

## Driver source

The working community `it87` driver is included as a Git submodule at `vendor/it87`, pinned to the tested revision.

```bash
git clone --recurse-submodules https://github.com/reonokiy/server1-config.git
```

For an existing checkout:

```bash
git submodule update --init --recursive
```

## Verify current state

```bash
bash scripts/check.sh
```

Sensor mappings originate from [frankcrawford/it87](https://github.com/frankcrawford/it87), commit `bd7a566c8a60fe0308d67e26761e16260368191a`. The upstream GPL-2.0 license is retained in `LICENSE.it87` for the copied mapping.
