# OPPO CPH2579 — Hardware and software baseline

Captured on 2026-09-12 using read-only ADB queries from Linux.

## Identity

| Property | Value |
|---|---|
| Manufacturer | OPPO |
| Model | CPH2579 |
| Device | OP5759L1 |
| Product | CPH2579EEA |
| Board | RM6769 |
| Hardware | mt6768 |

## Android

| Property | Value |
|---|---|
| Android release | 15 |
| API level | 35 |
| Build | `CPH2579_15.0.0.1900(EX01)` |
| Security patch | 2026-07-01 |

## CPU / ABI

- Primary ABI: `arm64-v8a`
- Supported ABIs: `arm64-v8a, armeabi-v7a, armeabi`
- 64-bit ABI list: `arm64-v8a`
- Kernel-reported CPU architecture: ARMv8

## Treble and update layout

| Feature | Result |
|---|---|
| Project Treble | `true` |
| Dynamic partitions | `true` |
| A/B updates | `true` |
| Virtual A/B | `true` |
| Active slot suffix | `_b` |
| Active slot | `b` |

The device exposes paired partitions including `boot_a`/`boot_b`, `init_boot_a`/`init_boot_b`, `dtbo_a`/`dtbo_b`, `vbmeta_a`/`vbmeta_b`, `vendor_boot_a`/`vendor_boot_b`, plus a `super` partition.

## Boot security

| Property | Result |
|---|---|
| `ro.boot.flash.locked` | `1` |
| `ro.boot.vbmeta.device_state` | `locked` |
| `ro.boot.verifiedbootstate` | `green` |
| `ro.oem_unlock_supported` | no value returned |
| `sys.oem_unlock_allowed` | `0` |

Interpretation: the bootloader is currently locked and Verified Boot is in its normal verified state. The empty `ro.oem_unlock_supported` result is recorded as unknown/not exposed, not as `false`.

## DSU / GSI observations

- Package present: `com.android.dynsystem`
- `ro.gsid.image_running`: no value returned
- `ro.gsid.image_installed`: no value returned
- VNDK property queries returned no value in this build.
- Vendor namespace grep used during the initial probe returned no match.

The presence of `com.android.dynsystem` is evidence that DSU components exist in the system image. It is not yet evidence that the OPPO build exposes a functional DSU Loader or accepts a compatible GSI in locked state.

## Boot state at capture

- `ro.bootmode`: `normal`
- `ro.boot.bootreason`: `rtc`

## Privacy

ADB serial numbers and any unique MediaTek identifiers are intentionally excluded from this repository.
