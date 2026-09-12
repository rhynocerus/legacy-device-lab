# OPPO OTA APK extraction — 2026-09-12

A read-only copy of the stock OPPO OTA application was pulled from the running CPH2579 for offline analysis.

## Source

```text
/system_ext/app/OTA/OTA.apk
```

The source APK was copied with `adb pull`; no package was modified, replaced or reinstalled on the device.

## Host copy

```text
Size: 15045027 bytes (~15 MiB)
SHA-256: f0c5281f31d00c91b8315cfe72fc66ec4fa102f6e88573f088cf0ffc4808d074
File type reported by `file`: Java archive data (JAR)
```

The APK contains at least two DEX files:

```text
classes.dex
classes2.dex
```

and bundled resources/assets, including PNG/WebP/OGG resources.

## Available local tools

At the time of extraction the Linux host had:

```text
unzip
zipinfo
strings
```

but not:

```text
jadx
jadx-gui
apktool
aapt
aapt2
```

## Purpose

The immediate goal is offline inspection of the stock OTA client to identify:

- EUEX/EEA firmware metadata handling;
- update-check endpoints and request parameters;
- package/download URL construction;
- component names and update-state handling;
- any references that can help locate the exact European OTA package for `CPH2579_15.0.0.1900(EX01)`.

This analysis is strictly observational at this stage. A modified OTA APK would not be installable as a drop-in replacement for the privileged stock package on the current locked/AVB-green device without satisfying Android signature, privileged-permission and verified-boot constraints.
