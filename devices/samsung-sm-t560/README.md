# Case 001: Samsung Galaxy Tab E 9.6 SM-T560

## Objective

Repurpose a Samsung Galaxy Tab E 9.6 SM-T560 (`gtelwifi`) as a lightweight Linux laboratory device, preferably using postmarketOS with a light desktop such as LXQt.

The tablet is dedicated lab hardware, so preservation of the existing Android installation is not a project requirement. The priority is avoiding unnecessary hard-brick risk while learning from the process.

## Current status

**Paused after USB/Download Mode diagnostics.**

The tablet boots Android normally and USB/MTP is stable. Samsung Download Mode enumerates as `04e8:685d` but disconnects spontaneously after roughly 1-2 seconds on the tested Linux host, even when no flashing software is running.

An upstream bug report has been opened:

- [Llucs/odin4#270](https://github.com/Llucs/odin4/issues/270)

A fork is available for future device-specific experiments:

- [rhynocerus/odin4](https://github.com/rhynocerus/odin4)

## What has been confirmed

- Exact model: **SM-T560**, not SM-T560NU.
- Codename: `gtelwifi`.
- Wi-Fi-only Galaxy Tab E 9.6 variant.
- Original Android environment remains bootable.
- Normal Android USB mode is stable.
- Download Mode is reachable with Volume Down + Home + Power, then Volume Up.
- Download Mode VID:PID: `04e8:685d`.
- Normal Android VID:PID observed: `04e8:6860`.
- Heimdall can occasionally detect the device but protocol initialization fails.
- Odin4 7.3.0 was successfully built from source on Linux.
- Odin4 `-l` cannot list the device because Download Mode frequently disconnects before or during enumeration.
- The spontaneous disconnect is reproducible without Heimdall or Odin4 running.

## Planned Linux path

If stable recovery/boot access becomes possible:

1. Install or boot a compatible recovery/kernel for SM-T560.
2. Use a MicroSD for most of the postmarketOS root filesystem if practical.
3. Install postmarketOS.
4. Prefer a lightweight interface such as LXQt.
5. Use the tablet for SSH, Python, Git, network diagnostics, dashboards and other lab tasks.

## Files

- [`hardware.md`](hardware.md): device and host information.
- [`usb-diagnostics.md`](usb-diagnostics.md): USB investigation and findings.
- [`linux-attempt.md`](linux-attempt.md): postmarketOS plan and blockers.
- [`logs/`](logs/): sanitized excerpts from relevant command output.

## Safety note

Commands in this case are historical lab notes, not universal flashing instructions. Samsung variants with similar names are not interchangeable. Always verify the exact model before writing boot, recovery or partition data.
