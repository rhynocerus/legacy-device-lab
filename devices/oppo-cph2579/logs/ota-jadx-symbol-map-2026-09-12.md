# OPPO CPH2579 — OTA JADX symbol map

Date: 2026-09-12

A local copy of `/system_ext/app/OTA/OTA.apk` was decompiled with JADX 1.5.6. JADX completed with partial decompilation errors, which is expected for a large vendor APK with obfuscated and framework-dependent classes; a usable source tree was produced.

## Relevant symbols located

### OTA service/control path

`oplus.intent.ota.CHECK_NEW_VERSION_UPDATE` and `oplus.intent.ota.PUSH_CHECK_NEW_VERSION_UPDATE` are referenced by:

- `com/oplus/ota/service/OTAService.java`
- `com/oplus/ota/strategy/StrategyReceiver.java`
- `com/oplus/ota/strategy/ConnectivityJobService.java`
- `i5/b.java`
- several OTA UI components

The main service handles both actions in its action dispatch logic around the decompiled `OTAService.java` lines ~3260–3280. This establishes that the actions are part of the actual ColorOS OTA control flow, not merely unused string resources.

### Region/dynamic-host symbols

The APK also contains reusable account/network libraries exposing symbols such as:

- `getHostByCurrentRegion`
- `getHostByRegion`
- `countryDomainMapping`
- `X-Client-Country`
- `getServerUrl`
- `getRomBuildOtaVersion`

However, the located `getServerUrl` definitions are in `com.platform.usercenter.*`, and `countryDomainMapping` is primarily in `com.platform.account.*`. These may support account/user-center networking rather than the firmware OTA backend. They must not be treated as confirmed OTA endpoints without call-graph evidence from `com.oplus.ota`.

## Next safe step

Inspect the decompiled source surrounding the OTA action dispatch and its direct callees before broadcasting any internal update action. Specifically inspect:

- `com/oplus/ota/service/OTAService.java`
- `i5/b.java`
- `com/oplus/ota/strategy/StrategyReceiver.java`
- `com/oplus/ota/strategy/ConnectivityJobService.java`

Then search the `com.oplus.ota` package specifically for Retrofit/OkHttp/request classes, URL builders, endpoint annotations, response models, and firmware metadata fields.

No OTA action has been manually triggered, no download has been initiated, and no device partition or package has been modified.