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
| `config/mise/config.toml` | `~/.config/mise/config.toml` |
| `config/bash/mise.bash` | Bash activation snippet; see setup notes |
| `etc/modules-load.d/it87.conf` | `/etc/modules-load.d/it87.conf` |
| `etc/sensors.d/gigabyte-it87.conf` | `/etc/sensors.d/gigabyte-it87.conf` |

- [Mise and GitHub CLI setup](docs/user-tools.md)
- [IT8696 fan monitoring fix and recovery](docs/fan-driver.md)
- [Initial performance screening](docs/performance.md)

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
