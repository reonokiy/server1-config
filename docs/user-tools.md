# User tools

Installed on 2026-10-22 (Asia/Singapore):

- mise `2026.10.15` in `~/.local/bin/mise`
- GitHub CLI `2.102.0`, installed through mise
- GitHub account `reonokiy`; HTTPS Git authentication; credentials in the system keyring

The tracked mise configuration follows `gh = "latest"`; the version above records the initial installed version.

## Restore

Download and inspect the official mise installer, then run it as the normal user:

```bash
curl -fsSL https://mise.run -o /tmp/mise-install.sh
less /tmp/mise-install.sh
sh /tmp/mise-install.sh
mkdir -p ~/.config/mise
cp config/mise/config.toml ~/.config/mise/config.toml
~/.local/bin/mise install
```

Add this once to `~/.bashrc` (the current machine already has equivalent activation):

```bash
export PATH="$HOME/.local/bin:$PATH"
if [ -x "$HOME/.local/bin/mise" ]; then
    eval "$("$HOME/.local/bin/mise" activate bash)"
fi
```

Open a new terminal or run `source ~/.bashrc`, then authenticate:

```bash
gh auth login --hostname github.com --git-protocol https --web
gh auth status
```

Complete the device authorization in your own browser. Never commit `~/.config/gh/hosts.yml` or authentication tokens.

References: [mise installation](https://mise.jdx.dev/getting-started.html), [GitHub login](https://cli.github.com/manual/gh_auth_login).
