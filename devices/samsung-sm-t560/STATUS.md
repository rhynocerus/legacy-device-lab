# Status

**Case 001 status:** Paused, upstream investigation open.

## Completed

- Exact model confirmed as Samsung SM-T560 (`gtelwifi`).
- Stable Android/MTP USB path confirmed.
- Download Mode VID:PID confirmed as `04e8:685d`.
- Spontaneous Download Mode disconnect reproduced without flashing software running.
- Heimdall behavior documented.
- Odin4 7.3.0 built successfully from source.
- Upstream Odin4 issue opened: [#270](https://github.com/Llucs/odin4/issues/270).
- Personal Odin4 fork prepared for future experiments.

## Waiting for

- maintainer feedback,
- a reproducible workaround,
- a meaningful host-controller comparison,
- or a safe boot/recovery path that avoids repeated blind flashing attempts.

## Success condition

A successful next phase means obtaining stable enough boot/recovery access to install a compatible Linux path, ideally postmarketOS with most user-space storage on MicroSD.
