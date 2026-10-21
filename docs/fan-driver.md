# Gigabyte IT8696 fan monitoring

## Diagnosis and verified fix

On 2026-10-22, the stock Ubuntu `it87` module failed with `No such device`. A targeted Super I/O scan with `sensors-detect` identified chip ID `0x8696` at configuration ports `0x2e/0x2f`.

The community [frankcrawford/it87](https://github.com/frankcrawford/it87) driver explicitly supports IT8696E. This exact revision was compiled, test-loaded, and installed successfully:

- Commit: `bd7a566c8a60fe0308d67e26761e16260368191a`
- DKMS version: `bd7a566.20261002`
- Kernel tested: `7.3.0-9-generic`
- Sensor name: `it8696_a0060507-isa-0a40`
- Board mapping/SIV: `0xa0060507`
- Secure Boot: disabled at installation

The driver was loaded without `force_id` or ACPI resource-conflict overrides. BIOS fan curves were left unchanged; PWM control was not tested. Reboot persistence is configured, but has not yet been verified by rebooting.

## Reproduce

Run from this repository. Review upstream source before privileged installation.

```bash
sudo apt-get install git build-essential dkms lm-sensors linux-headers-$(uname -r)
git clone https://github.com/frankcrawford/it87.git ~/it87
cd ~/it87
git checkout bd7a566c8a60fe0308d67e26761e16260368191a
make -j8
sudo insmod ./it87.ko
sensors
```

If another `it87` module is already loaded, inspect it before attempting the test load. After verifying readings, install the pinned revision through DKMS:

```bash
sudo make DRIVER=it87 DRIVER_VERSION=bd7a566.20261002 DKMS_ROOT_PATH=/usr/src/it87-bd7a566.20261002 dkms
```

Return to this repository and install the tracked startup and display configuration:

```bash
sudo install -m 644 etc/modules-load.d/it87.conf /etc/modules-load.d/it87.conf
sudo install -m 644 etc/sensors.d/gigabyte-it87.conf /etc/sensors.d/gigabyte-it87.conf
```

DKMS rebuilds the driver for future kernels when compatible headers are present. Check build status after kernel upgrades; future kernel compatibility is not guaranteed. Secure Boot, if enabled later, requires a trusted module-signing key.

## Verify

```bash
dkms status
modinfo -n it87
lsmod | grep it87
sensors it8696_a0060507-isa-0a40
watch -n 1 sensors
```

Expected module path includes `/updates/dkms/it87.ko.zst`. Initial idle readings were approximately:

| Header | RPM |
| --- | ---: |
| CPU_FAN | 1490 |
| SYS_FAN2 | 779 |
| CPU_OPT | 3082 |

Other channels reported zero; this alone does not establish a failed fan. Raw sensor alarm flags and thresholds have not been calibrated or diagnosed.

## Remove / recover

```bash
sudo rm -f /etc/modules-load.d/it87.conf
sudo rm -f /etc/sensors.d/gigabyte-it87.conf
sudo modprobe -r it87
sudo dkms remove -m it87 -v bd7a566.20261002 --all
sudo depmod -a
```

DKMS removal restores selection of the original kernel module. BIOS fan control remains independent. Avoid forcing chip IDs or ignoring ACPI conflicts without diagnosing the specific issue.
