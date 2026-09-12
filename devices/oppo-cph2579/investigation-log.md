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

## 2026-09-12 — Entry 002: DSU infrastructure present

### Read-only DSU checks

An initial probe using `android.settings.DYNAMIC_SYSTEM_UPDATE_SETTINGS` returned no activity. This action is not the AOSP DSU Loader action and therefore is **not** treated as evidence that ColorOS removed DSU Loader. The correct AOSP action is tested in Entry 003 below.

The underlying DSU implementation is present:

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

`enabled=0` is recorded as the PackageManager default-enabled state, not as evidence that the package is disabled.

### Developer/OEM state

```text
settings get global oem_unlock_allowed -> null
settings get global development_settings_enabled -> 1
```

The earlier system property still reported:

```text
sys.oem_unlock_allowed=0
```

Developer Options are enabled, but no standard OEM-unlock authorization is currently exposed through these queries.

### Storage

`/data` is F2FS and currently has approximately 62 GiB available, so storage capacity is not an immediate blocker for a normal-sized DSU experiment.

### Safety decision

No GSI was downloaded, selected, installed or booted. No persistent system property was changed. No partition or boot-security state was modified.

## 2026-09-12 — Entry 003: Stock AOSP DSU Loader is exposed by ColorOS

### Correct DSU Loader action

Resolving the AOSP DSU Loader action:

```text
android.settings.development.START_DSU_LOADER
```

returned:

```text
com.android.settings/.development.DSULoader
```

The `com.android.settings` package dump also explicitly lists the exported `DSULoader` component for that action.

This is strong evidence that the OPPO Android 15 build retains the stock-style AOSP DSU Loader front end.

### DSU feature properties

The following queried overrides returned no values:

```text
persist.sys.fflag.override.settings_dynamic_system
sys.fflag.override.settings_dynamic_system
persist.sys.fflag.override.settings_dynamic_system.list
```

A blank custom-list override is consistent with AOSP DSULoader falling back to its built-in Google GSI metadata URL. No property has been changed.

### Dynamic System installation handler

Resolving:

```text
android.os.image.action.START_INSTALL
```

returned:

```text
com.android.dynsystem/.VerificationActivity
```

The component accepts `content`, `file`, `http` and `https` URI schemes as well as the non-data form of the install action.

### Interpretation

The verified chain now includes:

- Treble enabled
- dynamic partitions enabled
- A/B and Virtual A/B enabled
- `gsi_tool` present and reporting `normal`
- `dynamic_system` Binder service present
- `gsiservice` Binder service present
- `com.android.settings/.development.DSULoader` resolvable
- `com.android.dynsystem/.VerificationActivity` resolvable
- approximately 62 GiB free in `/data`

The bootloader remains locked and AVB remains green. No GSI has been selected or installed.

### Next reversible action

Open the DSU Loader UI only:

```bash
adb shell am start -a android.settings.development.START_DSU_LOADER
```

Opening the activity is considered reversible. Do not select a GSI until the offered image metadata has been recorded and checked for architecture, Android version, VNDK/SPL constraints and expected signature behavior on this locked OPPO build.

## 2026-09-12 — Entry 004: DSU Loader opens but offers no compatible image

### USBGuard reconnection note

After a USB reconnect, the phone enumerated under a different OPPO USB product ID and USBGuard blocked the newly exposed configuration. ADB therefore showed no connected device until the corresponding USBGuard device entry was explicitly allowed. The unique device serial is intentionally omitted from this repository.

After authorization, `adb devices` again reported the phone as `device`.

### DSU Loader result

Launching:

```bash
adb shell am start -a android.settings.development.START_DSU_LOADER
```

successfully opened the stock DSU Loader UI. The phone displayed:

```text
Select DSU Package

No DSU available for this device.
```

This is not a network-error or metadata-error result. AOSP `DSULoader` displays this exact fallback string when it successfully processes the configured DSU metadata but its compatibility filtering leaves the package list empty.

### Relevant compatibility observations

The AOSP DSU Loader filters image metadata using, when present:

- `cpu_abi`, compared with `ro.product.cpu.abi`;
- `os_version`, which must not be older than the device system release;
- `vndk`, matched against `ro.vndk.version`;
- `spl`, which must not be older than the device security patch level.

The device is `arm64-v8a` and Android 15, but earlier read-only probes returned no visible value for `ro.vndk.version`. The device security patch level is `2026-07-01`.

### Safety status

No package was selected. No GSI was downloaded or installed. No persistent property was changed. The bootloader and verified-boot state remain untouched.

## 2026-09-12 — Entry 005: Logcat identifies security-patch rollback filtering

A cold launch of `DSULoader` was captured with the `DSULOADER` log tag. The loader successfully fetched Google's default GSI metadata and inspected ARM64 and x86-family images from Android 11 through Android 16.

For ARM64 packages, the device architecture matched. Older Android releases were also rejected because their OS version was below the device's Android 15 release. Most importantly, every candidate GSI had a security patch level older than the device's `2026-07-01` SPL.

Examples observed:

```text
Android 15 GSI SPL: 2025-04-05
Device SPL:          2026-07-01
Result:              isSupported false
```

```text
Android 16 GSI SPL: 2026-01-05
Device SPL:          2026-07-01
Result:              isSupported false
```

The queried properties were:

```text
ro.product.cpu.abi=arm64-v8a
ro.system.build.version.release=15
ro.vndk.version=<no value returned>
ro.build.version.security_patch=2026-07-01
```

No explicit VNDK rejection appeared in the captured log. Therefore the evidence currently supports **SPL anti-rollback filtering as the immediate reason the stock catalog produces zero DSU choices**. The empty VNDK property remains a compatibility question, but is not treated as the demonstrated blocker.

The current Google GSI release page should be checked separately for images newer than those exposed by the stock metadata feed before attempting any manual DSU installation.

## 2026-09-12 — Entry 006: Developer-GSI key visibility check

A read-only filesystem search was performed for public Developer-GSI AVB keys in locations visible from the running Android userspace, including:

```text
/avb
/first_stage_ramdisk/avb
/vendor_ramdisk/avb
/vendor/etc/avb
/system/etc/avb
```

and across `/system`, `/vendor`, `/product`, `/system_ext` and `/odm` for filenames matching Developer-GSI key patterns.

No matching key files were visible. A `/proc/1/root/avb` listing also produced no visible result in the unprivileged ADB shell context.

Boot-security properties remain unchanged:

```text
ro.boot.avb_version=1.3
ro.boot.vbmeta.device_state=locked
ro.boot.verifiedbootstate=green
ro.boot.flash.locked=1
```

### Interpretation

AOSP states that OEMs wishing to boot public Developer GSIs while the bootloader remains locked install the relevant GSI public keys into the first-stage ramdisk. Their absence from the running filesystem search **does not prove those keys are absent from the boot images**: the first-stage ramdisk may not be exposed to an ordinary ADB shell after boot, and access through `/proc/1/root` may be restricted.

The next safe step is therefore to determine whether the active `init_boot_b` / `vendor_boot_b` block devices can be read from the unprivileged shell, without writing anything. If they cannot, inspection should move to an official firmware/OTA package or another non-writing acquisition route rather than attempting a BROM or partition-unlock procedure.

## Decision gate

Do not proceed to bootloader/preloader modification until the DSU path has been exhausted and a recoverability plan exists.
