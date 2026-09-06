# Legacy Device Lab methodology

This document defines a repeatable workflow for investigating old hardware without turning every experiment into a pile of untraceable trial and error.

## 1. Identify exactly

Record the exact model, hardware revision, codename, architecture, storage layout, connector type and any bootloader/recovery identifiers visible on the device.

Never assume that files for a similarly named variant are interchangeable.

## 2. Establish a baseline

Before changing anything, record what still works:

- normal boot
- charging
- USB data
- Wi-Fi/Bluetooth
- display/touch
- removable storage
- recovery/download/fastboot modes

This makes later regressions measurable.

## 3. Reproduce before modifying

A useful failure report should answer:

- What exact steps trigger the problem?
- Does it happen every time?
- How long does it take?
- Does it occur without the flashing/debugging tool running?

## 4. Collect minimal diagnostics

Useful Linux commands include:

```bash
uname -a
lsusb
sudo dmesg -W
```

Tool-specific verbose/debug output can be useful, but collect it only after establishing whether the failure exists below the application layer.

## 5. Change one variable at a time

Typical variables:

- known-good data cable
- USB port
- USB 2 versus USB 3/xHCI path
- powered versus passive hub
- another host computer
- kernel version
- userspace driver/service conflicts
- alternative open-source tools

Record both successful and failed changes.

## 6. Sanitize before publishing

Remove information that is not necessary to reproduce the technical problem, including:

- access tokens
- passwords
- private keys
- personal email addresses
- public IP addresses when unnecessary
- MAC addresses when unnecessary
- unique device serial numbers when unnecessary

Keep technical identifiers such as USB VID:PID when they are relevant to compatibility.

## 7. Escalate upstream with evidence

Before opening a new issue:

1. Search existing issues.
2. Use the project's issue template when available.
3. Include exact versions, model, reproduction steps, expected behavior, actual behavior and sanitized logs.
4. Separate observation from hypothesis.

If maintainers request testing, use the physical hardware to validate one change at a time and report both positive and negative results.

## 8. Patch through a fork

When code changes become appropriate:

```text
upstream repository
        ↓ fork
personal fork
        ↓ branch
focused change
        ↓ tests on hardware
pull request
        ↓
upstream review
```

Do not mix unrelated fixes into the same pull request.

## 9. Record the outcome

Every case should end in one of these states:

- **Recovered**: the target system works as intended.
- **Workaround**: useful operation is possible through a documented alternative.
- **Partial**: some goals were reached, others remain blocked.
- **Paused**: waiting for new information, hardware, software or maintainer feedback.
- **Documented limitation**: the current path is understood well enough to save others repeated work.

A technically useful failure is still a valid lab result.
