# Case 002: OPPO CPH2579

## Goal

Investigate whether an OPPO CPH2579 can safely be repurposed as an Android/Linux experimentation device, prioritizing reversible and non-destructive methods before any bootloader, preloader, BROM or partition-writing work.

The preferred progression is:

1. Identify the exact hardware/software baseline.
2. Test whether Dynamic System Updates (DSU) can boot a compatible GSI without modifying the installed system.
3. Investigate official or low-risk bootloader unlock paths.
4. Only if justified, evaluate MediaTek tooling and upstream projects.
5. Consider a postmarketOS port only after the boot chain and device support are understood.

## Current baseline

- Manufacturer: OPPO
- Model: CPH2579
- Device: OP5759L1
- Product: CPH2579EEA
- Board: RM6769
- Hardware: mt6768
- Android: 15 (API 35)
- Build: `CPH2579_15.0.0.1900(EX01)`
- Security patch: 2026-07-01
- Primary ABI: `arm64-v8a`
- Treble: enabled
- Dynamic partitions: enabled
- A/B updates: enabled
- Virtual A/B: enabled
- Active slot: `b`
- Bootloader state: locked
- Verified Boot state: green
- `com.android.dynsystem`: present
- `sys.oem_unlock_allowed`: `0`
- `ro.oem_unlock_supported`: not exposed by the current build/property query

See [`hardware.md`](hardware.md) for the detailed baseline and [`investigation-log.md`](investigation-log.md) for dated results.

## Current assessment

The device has the architectural prerequisites that make GSI/DSU investigation worthwhile: ARM64, Treble, dynamic partitions, A/B and Virtual A/B. The presence of `com.android.dynsystem` confirms that Android's Dynamic System infrastructure is packaged on the device, but does not by itself prove that OPPO exposes a working DSU Loader or accepts Google-signed developer GSIs while the bootloader remains locked.

Conventional fastboot GSI flashing is not currently viable because the bootloader is locked. AOSP documents that normal GSI flashing requires a Treble-compliant device in an unlocked state.

The current `sys.oem_unlock_allowed=0` result means OEM unlocking is not presently authorized. This must not be interpreted as proof that unlocking is permanently impossible; further read-only checks and the Developer Options UI state are required.

## Safety boundary

Until explicitly promoted to a destructive phase, this case will not:

- write `preloader`, `seccfg`, `boot`, `init_boot`, `vbmeta` or `super`;
- run `fastboot flashing unlock`;
- run MediaTek write/unlock commands;
- disable AVB;
- erase user data;
- publish device serial numbers, ME_ID, SOC_ID or other unique identifiers.

## Upstream references

- Android DSU documentation: https://source.android.com/docs/core/ota/dynamic-system-updates
- Android bootloader locking/unlocking documentation: https://source.android.com/docs/core/architecture/bootloader/locking_unlocking
- Android GSI documentation: https://developer.android.com/topic/generic-system-image
- Existing CPH2579 mtkclient report: https://github.com/bkerler/mtkclient/issues/256
- OPPO MediaTek fastboot research project: https://github.com/Shocked-Cat/oppo-mtk-fastboot-unlock

### Upstream collaboration status

`bkerler/mtkclient#256` documents the same CPH2579 family on Android 15 and an `0x1d18` failure during DA upload. The issue was automatically closed as stale/not planned, so we will not duplicate it. If this lab produces reproducible new evidence, a concise follow-up or a new well-scoped report can be considered.

The `Shocked-Cat/oppo-mtk-fastboot-unlock` project targets OPPO MediaTek devices by modifying and writing the factory preloader. Its documentation explicitly warns that Android 14 to Android 15 transitions can produce unpredictable results. It is therefore research material only at this stage, not an approved procedure for this case.

## Status

**Active investigation — read-only / reversible phase.**
