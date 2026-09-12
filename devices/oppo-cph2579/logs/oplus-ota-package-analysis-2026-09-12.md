# OPPO CPH2579 — `com.oplus.ota` component map

Date: 2026-09-12

## Purpose

Record read-only discovery of the stock OPPO OTA application before any attempt to trigger update checks, download firmware, or modify the device.

## APK location

```text
package:/system_ext/app/OTA/OTA.apk
```

The package can therefore be copied to the host with `adb pull` for offline inspection without modifying the phone.

## UI entry points

The package has no normal launcher activity, but exposes OPPO-specific actions. The most relevant discovered entry is:

```text
com.oplus.ota.MAIN
  -> com.oplus.ota/com.oplus.otaui.activity.EntryActivity
```

Other OTA UI components include `OtaFeatureSelectActivity`, `OpexUpdateActivity`, `DescriptionActivity`, `AppointmentActivity`, `UpgradeInviteActivity`, `AgreementActivity`, enterprise download/package-info activities and questionnaire/feedback components.

## OTA strategy receiver

`com.oplus.ota/.strategy.StrategyReceiver` listens for several update workflow actions, including:

```text
oplus.intent.ota.OTA_CHECK_NEW_VERSION_UPDATE
oplus.intent.action.OTA_SHOW_DOWNLOAD_DIALOG
oplus.intent.action.OTA_DELAY_NOTIFY_REBOOT
oplus.intent.action.OTA_SHOW_WARNING_DIALOG
```

These are recorded for analysis only. No internal broadcast was sent during this step.

## OTA service

The package exposes:

```text
com.oplus.ota/.service.OTAService
```

protected by:

```text
oplus.permission.OPLUS_COMPONENT_SAFE
```

Relevant service actions include:

```text
oplus.intent.ota.PUSH_CHECK_NEW_VERSION_UPDATE
oplus.intent.ota.CHECK_NEW_VERSION_UPDATE
oplus.intent.action.OTA_AUTO_DOWNLOAD
oplus.intent.action.OTA_REPORT_DOWNLOAD_RESULT
oplus.intent.action.UPDATE_FINISH_REFRESH_UI
oplus.intent.action.OTA_DISABLE_SYSTEM_UPDATE
oplus.intent.ota.STATE_TRACKER_ACTION
oplus.intent.action.FLOW_CONTROL_CHECK
```

An enterprise OTA service is also present and protected by `com.oplus.permission.safe.UPDATE`.

## Interpretation

The stock full-firmware updater is clearly `com.oplus.ota`, with `EntryActivity` as the principal OTA UI entry and `OTAService`/`StrategyReceiver` coordinating update checks and workflow state.

Because many internal actions are permission-protected and because the immediate goal is firmware metadata discovery rather than changing update state, the next preferred step is **offline APK analysis**. Pulling `/system_ext/app/OTA/OTA.apk` to the Linux host is read-only and may reveal endpoint strings, region parameters, OTA metadata keys and code paths used for EUEX update queries.

No update check broadcast was manually injected, no firmware was downloaded, and no OTA state was changed in this step.
