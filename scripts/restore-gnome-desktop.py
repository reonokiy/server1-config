#!/usr/bin/env python3
"""Restore selected GNOME settings and the two personal desktop extensions."""

import argparse
from datetime import datetime
import json
import os
from pathlib import Path
import shutil

from gi.repository import Gio, GLib


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--install-rounded", type=Path)
    parser.add_argument("--check", action="store_true", help="Validate without writing")
    args = parser.parse_args()
    if os.geteuid() == 0:
        parser.error("Run as the desktop user, without sudo")
    root = Path(__file__).resolve().parent.parent
    data_root = Path(os.environ.get("XDG_DATA_HOME", str(Path.home() / ".local/share")))
    extensions = data_root / "gnome-shell/extensions"
    rounded_uuid = "rounded-window-corners@fxgn"
    ibus_uuid = "stable-ibus-candidates@local"
    rounded_source = args.install_rounded or extensions / rounded_uuid
    settings_source = Gio.SettingsSchemaSource.new_from_directory(
        str(rounded_source / "schemas"), Gio.SettingsSchemaSource.get_default(), False
    )
    snapshot = json.loads((root / "config/gnome/desktop-settings.json").read_text())
    pending = []
    for schema_id, values in snapshot["settings"].items():
        schema = settings_source.lookup(schema_id, True)
        if schema is None:
            raise RuntimeError(f"Missing schema: {schema_id}; see docs/gnome-desktop.md")
        settings = Gio.Settings.new_full(schema, None, None)
        for key, text in values.items():
            # Let the extension manage its own preference migration version.
            if key == "settings-version":
                continue
            schema_key = schema.get_key(key)
            value = GLib.Variant.parse(schema_key.get_value_type(), text, None, None)
            if not schema_key.range_check(value):
                raise ValueError(f"Out of range: {schema_id} {key}")
            if not settings.is_writable(key):
                raise RuntimeError(f"Locked setting: {schema_id} {key}")
            pending.append((settings, key, value))
    shell = Gio.Settings.new("org.gnome.shell")
    if shell.get_boolean("disable-user-extensions"):
        raise RuntimeError("User extensions are disabled; enable them before restoring")
    if not shell.is_writable("enabled-extensions"):
        raise RuntimeError("The enabled extensions list is locked")
    if args.check:
        print(f"Validated {len(pending)} settings; no changes made")
        return
    sources = [(root / "config/gnome/extensions" / ibus_uuid, extensions / ibus_uuid)]
    if args.install_rounded:
        sources.append((args.install_rounded, extensions / rounded_uuid))
    backup_root = data_root / "server1-config/backups" / datetime.now().strftime(
        "%Y%m%d-%H%M%S-%f"
    )
    backup_root.mkdir(parents=True)
    before = {}
    for settings, key, _ in pending:
        schema_id = settings.props.schema_id
        value = settings.get_user_value(key)
        before.setdefault(schema_id, {})[key] = (
            value.print_(True) if value is not None else None
        )
    enabled = list(shell.get_strv("enabled-extensions"))
    (backup_root / "settings-before.json").write_text(
        json.dumps({"settings": before, "enabled-extensions": enabled}, indent=2) + "\n"
    )
    for source, destination in sources:
        if destination.exists():
            shutil.copytree(destination, backup_root / destination.name)
        shutil.copytree(source, destination, dirs_exist_ok=True)
    for settings, key, value in pending:
        if not settings.set_value(key, value):
            raise RuntimeError(f"Could not save {settings.props.schema_id} {key}")
    for uuid in (ibus_uuid, rounded_uuid):
        if uuid not in enabled:
            enabled.append(uuid)
    if not shell.set_strv("enabled-extensions", enabled):
        raise RuntimeError("Could not save enabled extensions")
    Gio.Settings.sync()
    print(f"Restored {len(pending)} settings; previous state saved in {backup_root}")


if __name__ == "__main__":
    main()
