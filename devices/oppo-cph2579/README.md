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

The device has the architectural prerequisites that make GSI/DSU investigation worthwhile: ARM64, Treble, dynamic partitions, A/B and Virtual A/B. ColorOS also retains the stock-style AOSP DSU path: `gsi_tool`, the `dynamic_system` and `gsiservice` Binder services, `com.android.settings/.development.DSULoader`, and `com.android.dynsystem/.VerificationActivity` are all present.

The DSU Loader can be opened successfully while the bootloader remains locked. Its default Google catalog currently produces **No DSU available for this device**. Captured `DSULOADER` logs establish the reason: every ARM64 image offered by that catalog has a security patch level older than the phone's `2026-07-01` SPL, so rollback protection rejects it. The captured catalog reached Android 16 with a January 2026 SPL. The empty `ro.vndk.version` value remains an observation, but it was not the demonstrated rejection reason in this test.

Detailed evidence: [`logs/dsu-loader-filter-2026-09-12.md`](logs/dsu-loader-filter-2026-09-12.md).

Google's current public GSI release page separately lists an Android 17 QPR1 Beta ARM64 GSI with a July 2026 SPL. That makes a carefully controlled manual DSU investigation technically interesting, but the device is still AVB-green and bootloader-locked. AOSP requires appropriate Developer GSI public keys in the device's boot ramdisk/vendor ramdisk to boot public Developer GSIs in locked state, so key availability must be investigated before attempting installation.

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
- Current Android GSI releases: https://developer.android.com/topic/generic-system-image/releases
- Existing CPH2579 mtkclient report: https://github.com/bkerler/mtkclient/issues/256
- OPPO MediaTek fastboot research project: https://github.com/Shocked-Cat/oppo-mtk-fastboot-unlock

### Upstream collaboration status

`bkerler/mtkclient#256` documents the same CPH2579 family on Android 15 and an `0x1d18` failure during DA upload. The issue was automatically closed as stale/not planned, so we will not duplicate it. If this lab produces reproducible new evidence, a concise follow-up or a new well-scoped report can be considered.

The `Shocked-Cat/oppo-mtk-fastboot-unlock` project targets OPPO MediaTek devices by modifying and writing the factory preloader. Its documentation explicitly warns about unpredictable results around Android 15. It is therefore research material only at this stage, not an approved procedure for this case.

## Status

**Active investigation — read-only / reversible phase.**
