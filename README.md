# Legacy Device Lab

Recovering, repurposing and documenting legacy hardware with Linux and open-source tools.

> A practical lab for turning obsolete hardware into useful systems, while documenting the failures, quirks and reproducible solutions that may help others.

## Why this repository exists

Old hardware often remains physically useful long after official software support ends. This repository documents real attempts to understand, recover and repurpose those devices using Linux, open-source tools and careful diagnostics.

The goal is not only to reach a successful installation. Failed attempts, protocol incompatibilities and hardware-specific behavior are documented too, because those observations can be valuable to maintainers and other users.

## Cases

| Case | Device | Goal | Status |
|---|---|---|---|
| 001 | Samsung Galaxy Tab E 9.6 SM-T560 (`gtelwifi`) | Repurpose as a Linux lab tablet with postmarketOS | Investigation paused, upstream bug reported |
| 002 | OPPO CPH2579 (`OP5759L1`) | Evaluate DSU/GSI first, then bootloader/Linux possibilities | Active, read-only investigation |

### Case 001: Samsung SM-T560

The first case investigates a Samsung Galaxy Tab E 9.6 SM-T560 whose normal Android USB/MTP connection is stable, while Samsung Download Mode (`04e8:685d`) repeatedly disconnects and re-enumerates under Linux.

- Device notes: [`devices/samsung-sm-t560/`](devices/samsung-sm-t560/)
- USB diagnostics: [`usb-diagnostics.md`](devices/samsung-sm-t560/usb-diagnostics.md)
- Linux/postmarketOS attempt: [`linux-attempt.md`](devices/samsung-sm-t560/linux-attempt.md)
- Upstream report: [Llucs/odin4#270](https://github.com/Llucs/odin4/issues/270)
- Odin4 fork used for future experiments: [rhynocerus/odin4](https://github.com/rhynocerus/odin4)

### Case 002: OPPO CPH2579

The second case investigates an Android 15 OPPO CPH2579 with MediaTek hardware. Initial ADB inspection confirms ARM64, Project Treble, dynamic partitions, A/B and Virtual A/B support. The bootloader remains locked and Android Verified Boot is green.

The stock image also contains `com.android.dynsystem`, making a reversible DSU/GSI investigation the preferred next step before any bootloader, preloader or BROM modification.

- Case overview: [`devices/oppo-cph2579/`](devices/oppo-cph2579/)
- Hardware/software baseline: [`hardware.md`](devices/oppo-cph2579/hardware.md)
- Investigation log: [`investigation-log.md`](devices/oppo-cph2579/investigation-log.md)
- Related upstream report: [bkerler/mtkclient#256](https://github.com/bkerler/mtkclient/issues/256)

## Lab methodology

Each case should separate:

1. **Identification**: exact model, codename, architecture and interfaces.
2. **Baseline**: what still works before modification.
3. **Reproduction**: exact steps that trigger a failure.
4. **Diagnostics**: logs, USB identifiers, kernel messages and tool versions.
5. **Variable isolation**: cables, ports, drivers, kernels and alternative tools.
6. **Upstream collaboration**: issues, patches, pull requests and maintainer feedback.
7. **Outcome**: success, workaround, partial result or documented limitation.

See [`docs/methodology.md`](docs/methodology.md).

## Principles

- Prefer reproducible evidence over guesses.
- Keep device-specific notes separate from general conclusions.
- Never publish credentials, tokens, personal identifiers or unnecessary serial numbers.
- Preserve upstream attribution and licenses.
- Document failures as carefully as successes.
- Avoid destructive operations unless the device is explicitly designated as expendable lab hardware.

## Repository structure

```text
legacy-device-lab/
├── README.md
├── devices/
│   ├── samsung-sm-t560/
│   │   ├── README.md
│   │   ├── hardware.md
│   │   ├── linux-attempt.md
│   │   ├── usb-diagnostics.md
│   │   └── logs/
│   └── oppo-cph2579/
│       ├── README.md
│       ├── hardware.md
│       └── investigation-log.md
├── docs/
│   └── methodology.md
├── scripts/
│   └── collect-usb-diagnostics.sh
├── CONTRIBUTING.md
└── LICENSE
```

## Contributing

Reports about the same hardware, corrections, additional logs and reproducible workarounds are welcome. Please remove personal or sensitive information before publishing logs.

## License

The original material in this repository is released under the MIT License. Third-party projects referenced here retain their own licenses and copyrights.
