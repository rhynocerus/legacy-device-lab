# OPPO CPH2579 — Investigation log

## 2026-09-12 — Entry 001: USB and ADB baseline

### Host observations

The phone enumerated over USB as an OPPO CPH2579. USBGuard prompted for authorization and the device was allowed.

ADB initially returned an empty device list. After enabling USB debugging and authorizing the host computer on the phone, ADB reported the device state as `device`.

Unique ADB serial information is intentionally omitted.

### Read-only identification results

- OPPO CPH2579 / product `CPH2579EEA`
- Device identifier: `OP5759L1`
- Board: `RM6769`
- Hardware property: `mt6768`
- Android 15 / API 35
- Build: `CPH2579_15.0.0.1900(EX01)`
- Security patch: 2026-07-01
- Primary ABI: `arm64-v8a`

### Partition/update architecture

The following properties all returned `true`:

- Treble
- dynamic partitions
- A/B updates
- Virtual A/B

The current active slot is `b`.

Key block-device aliases confirm an A/B-style layout, including paired boot, init_boot, dtbo, vbmeta and vendor_boot partitions, plus `super` and `userdata`.

### Boot security

```text
ro.boot.flash.locked=1
ro.boot.vbmeta.device_state=locked
ro.boot.verifiedbootstate=green
```

The device is therefore still in its stock verified/locked state.

### DSU observations

`com.android.dynsystem` is installed.

The initial queries for GSI running/installed state returned no values, which is consistent with no active DSU instance but is not sufficient on its own to prove DSU Loader availability.

### OEM unlocking observations

```text
ro.oem_unlock_supported=<no value returned>
sys.oem_unlock_allowed=0
```

This is recorded as: **unlocking not currently authorized; permanent support status not yet established**.

AOSP specifies that devices supporting the standard flashing-unlock model should expose `ro.oem_unlock_supported=1`. Because this OPPO build returned no value rather than an explicit `0`, the result should not be over-interpreted.

### Relevant upstream work discovered

1. `bkerler/mtkclient#256` concerns an OPPO CPH2579 on Android 15 and reports MediaTek DA upload failure `0x1d18`. The report was later closed as stale/not planned.
2. `Shocked-Cat/oppo-mtk-fastboot-unlock` researches restoring fastboot access on OPPO MediaTek devices by modifying/writing the preloader. Its own documentation warns about unpredictable results around Android 15.

No BROM, mtkclient write, seccfg write, preloader patching or fastboot unlock operation has been attempted in this lab.

## Next safe checks

Before any destructive action, investigate:

- whether ColorOS exposes **DSU Loader** in Developer Options;
- `settings`/`dumpsys` state related to OEM unlocking;
- DSU service/component availability;
- filesystem type and free-space prerequisites for DSU;
- whether a Google/OEM-signed compatible GSI can be offered through the stock DSU flow;
- recovery/boot modes using non-writing commands only.

## Decision gate

Do not proceed to bootloader/preloader modification until the DSU path has been exhausted and a recoverability plan exists.
