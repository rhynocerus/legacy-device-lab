# OPPO CPH2579 — OTA.apk static string analysis

Date: 2026-09-12

## Source

Pulled from the stock device without modification:

```text
/system_ext/app/OTA/OTA.apk
```

Local SHA-256:

```text
f0c5281f31d00c91b8315cfe72fc66ec4fa102f6e88573f088cf0ffc4808d074
```

The APK contains at least `classes.dex` and `classes2.dex`.

## Method

The DEX files were read directly from the APK and passed through `strings -n 6`. No APK modification, rebuilding or installation was performed.

## Region and host-routing indicators

Notable strings include:

```text
countryDomainMapping
getHostByCurrentRegion
getHostByRegion
X-Client-Country
X-Context-Country
X-Context-MaskRegion
X-Safety-MarketName
persist.sys.oplus.region
ro.oplus.pipeline.region
ro.vendor.oplus.regionmark
ro.vendor.oplus.market.name
getRegionMark
getCountry
getCurRegion
```

This strongly suggests that the updater selects or resolves OTA backend hosts dynamically according to region/country/device-market metadata rather than embedding one globally fixed endpoint.

## OTA / update indicators

Notable strings include:

```text
getServerUrl
getRomBuildOtaVersion
CHECK_NEW_VERSION_UPDATE
PUSH_CHECK_NEW_VERSION_UPDATE
MSG_REQUEST_APP_CHECK_UPDATE
MSG_REQUEST_APP_START_DOWNLOAD
MSG_REQUEST_APP_RESUME_DOWNLOAD
MSG_REQUEST_APP_CANCEL_DOWNLOAD
newVersion
downloadSpeed
downloadState
totalSize
X-Op-Upgrade
```

Retrofit/HTTP client related strings are also present, including interceptor and annotation classes.

## URL observation

The raw DEX string pass did not reveal stock OTA HTTP(S) backend URLs. The only clear URLs found were Android XML schema URLs.

This suggests that the actual OTA endpoint is likely one of the following:

- assembled at runtime;
- supplied by dynamic host configuration;
- stored in an encoded/obfuscated form;
- retrieved from a separate service or configuration layer.

## Next step

Use a DEX/APK decompiler such as JADX to inspect the implementation around:

- `getServerUrl`
- `getHostByCurrentRegion`
- `countryDomainMapping`
- `getRomBuildOtaVersion`
- OTA check/download request construction

The goal remains offline analysis only. No OPPO OTA broadcast, service invocation, APK replacement or system modification is approved at this stage.
