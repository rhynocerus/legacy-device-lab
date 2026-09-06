# USB diagnostics

## Summary

The Samsung SM-T560 behaves differently in normal Android mode and Samsung Download Mode on the tested Linux host.

### Stable path

Normal Android USB/MTP:

```text
04e8:6860 SAMSUNG_Android
```

This remains connected using the known-good Micro-USB data cable.

### Unstable path

Samsung Download Mode:

```text
04e8:685d SAMSUNG USB DRIVER
```

The device initially enumerates successfully, then disconnects after roughly 1-2 seconds and attempts to re-enumerate.

This behavior occurs even when no flashing software is running.

## Important reproduction

With `ModemManager` stopped:

```bash
sudo systemctl stop ModemManager
sudo dmesg -W
```

Then enter Download Mode and connect the tablet, without running Odin4, Heimdall, ADB or `lsusb`.

Observed sequence:

```text
usb 1-3: new high-speed USB device number 78 using xhci_hcd
usb 1-3: New USB device found, idVendor=04e8, idProduct=685d, bcdDevice= 2.1b
usb 1-3: Product: SAMSUNG USB DRIVER
usb 1-3: Manufacturer: SAMSUNG
usb 1-3: USB disconnect, device number 78
usb 1-3: new high-speed USB device number 79 using xhci_hcd
usb 1-3: New USB device found, idVendor=04e8, idProduct=685d, bcdDevice= 2.1b
usb 1-3: Product: SAMSUNG USB DRIVER
usb 1-3: Manufacturer: SAMSUNG
```

This is the strongest finding in the investigation because it shows that the initial disconnect is not caused exclusively by Odin4 or Heimdall.

## Additional errors seen during failed re-enumeration

```text
device descriptor read/64, error -71
device descriptor read/64, error -110
can't set config #1, error -75
device not accepting address, error -71
unable to enumerate USB device
```

## Heimdall behavior

At least once:

```text
Device detected
```

Protocol initialization then failed with timeout/handshake errors:

```text
ERROR: libusb error -7 whilst sending bulk transfer. Retrying...
ERROR: Failed to send handshake!
ERROR: Failed to receive handshake response. Result: -7
ERROR: Protocol initialisation failed!
```

Earlier verbose enumeration showed a Samsung CDC-style layout with interface 1 exposing bulk endpoints `0x81` IN and `0x02` OUT.

## Odin4 behavior

Odin4 7.3.0 was built from source successfully. Running:

```bash
sudo ./build/odin4 -l
```

returned:

```text
No devices detected in Download Mode.
```

At the time of the check, Linux no longer listed `04e8:685d`, because the device had already disconnected or failed re-enumeration.

## Variables tested

- Multiple Micro-USB cables.
- Known-good data cable confirmed through stable Android MTP.
- Multiple USB ports.
- USB 2.0 and USB 3.x host paths.
- Front and rear host ports.
- `ModemManager` stopped.
- `cdc_acm` temporarily unloaded.
- Heimdall and Odin4 tested separately.
- Passive observation with no flashing tool running.

## Current interpretation

The evidence does not yet prove whether the root cause is:

- device-specific Download Mode firmware behavior,
- electrical/physical marginality that only appears in Download Mode,
- Linux xHCI interaction with this old Samsung bootloader,
- or another compatibility problem.

It does show that the issue exists below the normal Android/MTP layer and is reproducible independently of the flashing applications.

## Upstream

Bug report: [Llucs/odin4#270](https://github.com/Llucs/odin4/issues/270)
