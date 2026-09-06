#!/usr/bin/env bash
set -u

# Legacy Device Lab: lightweight USB diagnostic collector.
# This script only reads system information. It does not flash, reset or write to a device.

OUT_DIR="${1:-usb-diagnostics-$(date +%Y%m%d-%H%M%S)}"
mkdir -p "$OUT_DIR"

echo "Collecting read-only USB diagnostics into: $OUT_DIR"

{
  echo "# date"
  date --iso-8601=seconds 2>/dev/null || date
  echo
  echo "# uname -a"
  uname -a
} > "$OUT_DIR/system.txt"

{
  echo "# lsusb"
  lsusb
} > "$OUT_DIR/lsusb.txt" 2>&1

{
  echo "# recent kernel USB messages"
  dmesg 2>/dev/null | grep -iE 'usb|xhci|ehci|ohci|uhci' | tail -n 250
} > "$OUT_DIR/dmesg-usb.txt" 2>&1

{
  echo "# loaded modules commonly relevant to USB/serial devices"
  lsmod | grep -E 'cdc_acm|usbserial|xhci|ehci|ohci|uhci' || true
} > "$OUT_DIR/modules.txt" 2>&1

cat > "$OUT_DIR/README.txt" <<'EOF'
Before publishing these logs, review them manually.
Remove serial numbers, MAC addresses, IP addresses, usernames or any other information that is not required to reproduce the technical problem.
EOF

echo "Done. Review and sanitize the files before publishing them."
