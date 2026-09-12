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

## 2026-09-12 — Entry 002: DSU infrastructure present, public Settings entry absent

### Read-only DSU checks

Resolving the public Settings intent:

```text
android.settings.DYNAMIC_SYSTEM_UPDATE_SETTINGS
```

returned:

```text
No activity found
```

Starting the same action explicitly with `am start` also failed because ColorOS exposes no activity for that Settings action.

However, the underlying DSU implementation is present:

```text
/system/bin/gsi_tool
```

and `gsi_tool status` returned:

```text
normal
```

The following Binder services are registered:

```text
dynamic_system: android.os.image.IDynamicSystemService
gsiservice: android.gsi.IGsiService
oem_lock: android.service.oemlock.IOemLockService
```

`com.android.dynsystem` is installed as the privileged `DynamicSystemInstallationService` package and contains `VerificationActivity`.

### Package state

The package dump reports:

```text
installed=true
hidden=false
suspended=false
enabled=0
```

`enabled=0` is recorded as the PackageManager default-enabled state, not as evidence that the package is disabled. Further component-specific checks are required before drawing conclusions.

### Developer/OEM state

```text
settings get global oem_unlock_allowed -> null
settings get global development_settings_enabled -> 1
```

The earlier system property still reported:

```text
sys.oem_unlock_allowed=0
```

The distinction is retained: Developer Options are enabled, but no standard OEM-unlock authorization is currently exposed through these queries.

### Storage

`/data` is F2FS and currently has approximately 62 GiB available, so storage capacity is not an immediate blocker for a normal-sized DSU experiment.

### AOSP comparison

AOSP Settings normally declares an exported `com.android.settings.development.DSULoader` activity using the action `android.settings.development.START_DSU_LOADER`. The stock Dynamic System Installation Service also declares an exported `com.android.dynsystem.VerificationActivity` for `android.os.image.action.START_INSTALL`, protected by the privileged `android.permission.INSTALL_DYNAMIC_SYSTEM` permission.

Therefore, the next reversible investigation should first determine whether OPPO retained the explicit Settings `DSULoader` component even though it removed the public `DYNAMIC_SYSTEM_UPDATE_SETTINGS` action.

AOSP documentation also describes the `persist.sys.fflag.override.settings_dynamic_system` feature property. Changing that property is deliberately deferred until its current value and the actual OPPO component layout are inspected.

### Safety decision

No GSI was downloaded, selected, installed or booted. No persistent system property was changed. No partition or boot-security state was modified.

## Next safe checks

Before any destructive action, investigate:

- whether `com.android.settings.development.DSULoader` exists in the OPPO Settings package;
- whether the `android.settings.development.START_DSU_LOADER` action resolves;
- current `settings_dynamic_system` feature-property values;
- component-level enabled/exported state for DSU Loader and `VerificationActivity`;
- whether the Settings DSU Loader can be opened without starting an installation;
- only after those checks, decide whether enabling the documented DSU feature property is justified and reversible.

## Decision gate

Do not proceed to bootloader/preloader modification until the DSU path has been exhausted and a recoverability plan exists.
