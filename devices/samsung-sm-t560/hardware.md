# Hardware and environment

## Tablet

- Manufacturer: Samsung
- Product family: Galaxy Tab E 9.6
- Exact model: **SM-T560**
- Codename: `gtelwifi`
- Variant: Wi-Fi only
- Original Android observed: Android 4.4.4
- USB connector: Micro-USB
- Lab role: expendable test hardware for Linux/open-source repurposing

## Download Mode

Observed on-device identification:

- `PRODUCT NAME: SM-T560`
- `CURRENT BINARY: Samsung Official`
- `SYSTEM STATUS: Official`

Observed USB identity:

```text
VID:PID 04e8:685d
Product: SAMSUNG USB DRIVER
Manufacturer: SAMSUNG
```

## Normal Android USB mode

Observed USB identity:

```text
VID:PID 04e8:6860
Product: SAMSUNG_Android
Manufacturer: SAMSUNG
```

The normal Android/MTP connection remains stable with the same cable and host that show instability in Download Mode.

## Linux host used for primary testing

- Distribution: Linux Mint, Ubuntu Noble base
- Kernel: `6.8.0-138-generic`
- Architecture: `x86_64`
- USB host controller path observed: `xhci_hcd`
- libusb: `1.0.27`

## Tools

- ADB: `1.0.41`, Debian/Ubuntu package version 34.0.4
- Heimdall: `2.0.2`
- Odin4: `7.3.0-a46321b`
- GCC/G++ used to build Odin4: `14.2.0`
- CMake: `3.28.3`
- Ninja: `1.11.1`

## Notes

The exact SM-T560 identity matters. Files for similarly named Samsung variants such as SM-T560NU must not be assumed compatible.
