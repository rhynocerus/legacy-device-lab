# OPPO CPH2579 — boot partition read check

Date: 2026-09-12

## Purpose

Determine whether the active-slot boot ramdisk partitions can be read from an ordinary ADB shell without modifying the device.

## Observed block-device aliases

```text
boot_b        -> /dev/block/mmcblk0p48
init_boot_b   -> /dev/block/mmcblk0p50
vendor_boot_b -> /dev/block/mmcblk0p49
```

SELinux labels observed through `ls -lZ`:

```text
boot_b        u:object_r:boot_block_device:s0
init_boot_b   u:object_r:block_device:s0
vendor_boot_b u:object_r:block_device:s0
```

## Read test

A non-writing `dd` test attempted to read only 4 KiB from `init_boot_b` and `vendor_boot_b` into `/dev/null`.

Both reads failed with:

```text
Permission denied
0+0 records in
0+0 records out
0 bytes copied
```

## Interpretation

The partition aliases are visible to the unprivileged ADB shell, but direct block reads are denied by the running Android security context. No partition data was obtained and no bytes were written.

This closes the simple on-device extraction route for inspecting Developer-GSI AVB keys. The preferred next step is to inspect the exact stock OTA/firmware package externally on the Linux host rather than escalating privileges, modifying SELinux, using BROM, or writing any boot-related partition.

## Firmware lead

A public firmware index lists an OTA package matching the installed build `CPH2579_15.0.0.1900(EX01)`, approximately 4.98 GB, dated 2026-08-01, with MD5 `4d936a6dca284b82722c7e2e6c197866`. The indexed download points to an OPlus/OPPO-style `allawnofs.com` OTA CDN URL.

This source should be treated as a lead rather than blindly trusted. Before using any extracted image, verify the package hash and inspect metadata to confirm model/product/build identity. No firmware has been downloaded or flashed as part of this check.

## Safety status

- bootloader remains locked
- AVB remains green
- no root used
- no BROM/preloader operation used
- no partition written
- no device-unique identifier published
