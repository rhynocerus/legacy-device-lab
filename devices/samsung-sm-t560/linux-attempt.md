# Linux / postmarketOS attempt

## Goal

Turn the Samsung Galaxy Tab E 9.6 SM-T560 into a lightweight Linux lab tablet.

Desired uses include:

- SSH client and remote administration
- Python scripting
- Git
- network diagnostics
- lightweight dashboards
- browser-based lab interfaces
- general experimentation with Linux on constrained hardware

## Preferred target

postmarketOS was selected as the most promising Linux path for this model, with a lightweight desktop such as LXQt preferred over heavier environments.

## Intended architecture

A practical future layout would be:

```text
internal storage
└── minimal boot/recovery components required by the device

MicroSD
└── postmarketOS root filesystem and most user-space data
```

The MicroSD can reduce writes to internal storage, but it does not currently eliminate the need to gain a working boot/recovery path on this model.

## Current blocker

A compatible recovery/kernel cannot safely be installed until Samsung Download Mode communication is stable enough to perform a controlled write.

The current Linux host sees `04e8:685d` briefly, then the tablet disconnects and re-enumerates even with no flashing utility running.

See [`usb-diagnostics.md`](usb-diagnostics.md).

## Tools investigated

### Heimdall

- Device detection succeeded intermittently.
- PIT/handshake initialization failed with libusb timeout `-7`.

### Odin4

- Modern native Linux Samsung flashing tool.
- Version built: `7.3.0-a46321b`.
- Built successfully with GCC/G++ 14 after disabling the optional Qt GUI and test targets.
- The device cannot currently remain enumerated long enough for a reliable Odin4 session.

Build configuration used:

```bash
CC=gcc-14 CXX=g++-14 cmake -S . -B build -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DODIN4_BUILD_GUI=OFF \
  -DODIN4_BUILD_TESTS=OFF

cmake --build build --parallel "$(nproc)"
```

## Why the project is paused rather than abandoned

The tablet still has several positive indicators:

- Android boots.
- USB/MTP works in normal Android mode.
- Download Mode is accessible.
- Exact model identification is confirmed.
- Linux community work exists for `gtelwifi`.
- The hardware can still serve as a useful compatibility test device.

The next step should follow new upstream information, a reproducible workaround, a different host-controller result, or a maintainer-requested test rather than repeated blind flashing attempts.

## Upstream collaboration

- Bug report: [Llucs/odin4#270](https://github.com/Llucs/odin4/issues/270)
- Fork reserved for experiments: [rhynocerus/odin4](https://github.com/rhynocerus/odin4)

Any future code change should be made in a focused branch in the fork and proposed upstream only after it is testable on the physical SM-T560.
