#!/usr/bin/env bash
set -euo pipefail
printf '%s\n' 'Mise:'
"$HOME/.local/bin/mise" --version
printf '%s\n' 'GitHub CLI:'
"$HOME/.local/bin/mise" exec -- gh --version
printf '%s\n' 'DKMS:'
dkms status
printf '%s\n' 'Selected driver:'
modinfo -n it87
printf '%s\n' 'Startup module:'
cat /etc/modules-load.d/it87.conf
printf '%s\n' 'Fan readings:'
sensors it8696_a0060507-isa-0a40
