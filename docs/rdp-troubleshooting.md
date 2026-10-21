# macOS RDP connection hang — investigation paused

Status as of 2026-10-22: retain the current installation. No FreeRDP upgrade, downgrade, or custom-library override has been applied. Remote desktop has not been verified end to end from the Mac.

## Observed state

- Ubuntu 26.10 with GNOME Remote Desktop `51.0-0ubuntu1`.
- FreeRDP/WinPR packages `libfreerdp-server3-3`, `libfreerdp3-3`, and `libwinpr3-3`: `3.32.1+dfsg-1`.
- GNOME Remote Login system service and its local-access firewall service were active and enabled at boot.
- The Mac's RDP connection reached the server through its tailnet and was forwarded to the local RDP listener. TCP remained established while Windows App displayed “Connecting” without an error.
- The configured credentials matched the private credential file. This verifies storage, not successful authentication from the Mac.
- A local negotiation and TLS 1.3 handshake succeeded. This test did not authenticate or create a graphical session.
- Earlier “Credentials are not set” errors were fixed during setup. The subsequent local probe intentionally disconnected before authentication, producing transport/NLA errors; those entries do not establish a Mac authentication failure.

## Likely cause

The symptoms and installed library version strongly match the upstream FreeRDP 3.32.x regression affecting Microsoft Windows App on macOS. It can stall after CredSSP authentication when the server negotiates HYBRID_EX (extended security).

A local protocol probe confirmed:

| Client offer | Selected server protocol |
| --- | --- |
| SSL + HYBRID (`0x03`) | HYBRID (`0x02`) |
| SSL + HYBRID + HYBRID_EX (`0x0b`, as offered by Windows App) | HYBRID_EX (`0x08`) |

This is a likely diagnosis, not a proven resolution: no fixed-library build or successful post-fix Mac connection has been tested.

References:

- [FreeRDP 3.32.1 macOS Windows App hang, issue 13583](https://github.com/FreeRDP/FreeRDP/issues/13583)
- [HYBRID_EX/CredSSP ordering regression, issue 13549](https://github.com/FreeRDP/FreeRDP/issues/13549)
- [Upstream fix, pull request 13552](https://github.com/FreeRDP/FreeRDP/pull/13552)
- [FreeRDP 3.32.2 release, including the fix](https://github.com/FreeRDP/FreeRDP/releases/tag/3.32.2)

## Deferred repair

An Ubuntu package metadata refresh still offered only `3.32.1+dfsg-1`. Recheck the distribution's candidate before proceeding; an updated Ubuntu package containing the fix is preferable when available.

```bash
apt-cache policy libfreerdp-server3-3 libfreerdp3-3 libwinpr3-3
```

If the fixed package remains unavailable, the proposed alternative is to build a fixed upstream 3.x release (3.32.2 was the identified release) into an isolated prefix such as `/opt/freerdp-3.32.2`, then configure the relevant GNOME Remote Desktop service processes to use its compatible libraries. Verify library resolution for both the system listener and any session/handover processes before testing.

The isolated-prefix approach is a proposal, not an implemented or validated installation procedure. Do not mix Ubuntu releases or replace package-managed libraries manually. See [upstream build instructions](https://github.com/FreeRDP/FreeRDP/wiki/Compilation).

After a repair, verify the loaded libraries, restart only the relevant RDP services, and test a complete connection from Windows App, including authentication and graphical login. Keep the existing network access restrictions in place. If the isolated-library approach is used, rollback should remove only its specific overrides and restart the affected services, restoring the distro libraries; retain existing TLS, authentication, and firewall settings.

## Privacy and scope

This public note intentionally excludes tailnet addresses, coordination-server details, proxy profiles, credentials, keys, and raw logs. Private runtime configuration and credential files remain outside this repository. This note records the investigation and deferred repair only.
