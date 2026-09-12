# DSU Loader filtering evidence — 2026-09-12

Device: OPPO CPH2579 (unique identifiers intentionally omitted)

## Test

A cold start of the stock Android DSU Loader was captured with the `DSULOADER` logcat tag after clearing the logs.

```bash
adb shell am force-stop com.android.settings
adb logcat -b all -c
adb shell am start -W -a android.settings.development.START_DSU_LOADER
sleep 15
adb logcat -b all -d -v time 'DSULOADER:V' '*:S'
```

## Device properties relevant to filtering

```text
ro.product.cpu.abi              = arm64-v8a
ro.system.build.version.release = 15
ro.vndk.version                 = <empty>
ro.build.version.security_patch = 2026-07-01
```

## Catalog behavior

The stock loader successfully fetched Google's default metadata source:

```text
https://dl.google.com/developers/android/gsi/gsi-src.json
```

It then fetched descriptor files for Android 11 through Android 16. The ARM64 entries matched the device ABI, but every candidate was rejected.

Representative evidence:

```text
Android 11 ARM64: 11 < 15
Device SPL 2026-07-01 > GSI SPL 2020-09-05
GSI ARM64 isSupported false

Android 14 ARM64: 14 < 15
Device SPL 2026-07-01 > GSI SPL 2023-12-05
GSI ARM64 isSupported false

Android 15 ARM64:
Device SPL 2026-07-01 > GSI SPL 2025-04-05
GSI ARM64 isSupported false

Android 16 ARM64:
Device SPL 2026-07-01 > GSI SPL 2026-01-05
GSI ARM64 isSupported false
```

x86/x86_64 images were additionally rejected because their ABI does not match `arm64-v8a`.

## Conclusion

The observed blocker is rollback protection based on security patch level. The loader's current default catalog contains no ARM64 candidate with an SPL at least as recent as the device's `2026-07-01` SPL.

The empty `ro.vndk.version` value was recorded, but the captured log does not show VNDK as the reason these catalog entries were rejected. It should therefore not be treated as the established blocker for this test.

## Current upstream comparison

Google's public GSI releases page currently lists Android 17 QPR1 Beta ARM64 images with a **July 2026** security patch level (build `CP31.260623.013`). This is newer catalog content than the stock DSU Loader's default metadata exposed during the test.

Official references:

- https://developer.android.com/topic/generic-system-image/releases
- https://source.android.com/docs/core/ota/dynamic-system-updates

## Safety status

No GSI was selected, downloaded by the device, installed or booted. No persistent property was changed. Bootloader and AVB state remain untouched.
