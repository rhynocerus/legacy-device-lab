# JADX decompilation of OPPO OTA.apk

Date: 2026-09-12

## Source APK

Read-only copy pulled from the device:

```text
/system_ext/app/OTA/OTA.apk
```

Local SHA-256 recorded previously:

```text
f0c5281f31d00c91b8315cfe72fc66ec4fa102f6e88573f088cf0ffc4808d074
```

## Tool

JADX 1.5.6 was installed locally and used both from CLI and GUI.

Command:

```bash
jadx -d analysis/jadx OTA.apk
```

Result:

```text
INFO  - loading ...
INFO  - processing ...
ERROR - finished with errors, count: 83
```

The GUI opened successfully and the source tree was available. The package/class namespace is heavily obfuscated, with many short package names, but useful semantic strings and method names remain recoverable.

## Interpretation

The 83 decompilation errors do not invalidate the analysis. For a large vendor APK with obfuscation and internal framework dependencies, partial decompilation failures are expected. The generated source tree is still suitable for targeted searches.

Useful identifiers already recovered from strings/decompiled output include:

```text
getServerUrl
getRomBuildOtaVersion
getHostByCurrentRegion
getHostByRegion
countryDomainMapping
X-Client-Country
CHECK_NEW_VERSION_UPDATE
PUSH_CHECK_NEW_VERSION_UPDATE
```

These identifiers strongly suggest that the updater selects backend hosts dynamically according to region/country instead of embedding a single cleartext OTA URL.

## Next step

Search the JADX-generated sources for the surviving semantic identifiers and follow the call chain around host selection, OTA build-version construction and update-check requests. No code from the APK will be executed or modified on-device during this phase.
