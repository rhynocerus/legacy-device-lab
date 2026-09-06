# Upstream collaboration

## Odin4

Primary upstream project:

- https://github.com/Llucs/odin4

Reported issue:

- https://github.com/Llucs/odin4/issues/270

Personal fork reserved for device-specific testing:

- https://github.com/rhynocerus/odin4

## Collaboration workflow

If maintainers request a code experiment:

1. Create or use a focused branch in `rhynocerus/odin4`.
2. Apply the smallest possible change.
3. Build Odin4 successfully.
4. Test on the physical SM-T560.
5. Record the exact result in this case folder.
6. If the result is useful and maintainable, open a pull request against `Llucs/odin4:main`.

No device-specific patch has been proposed upstream yet.
