#!/bin/bash
# Flash Ubuntu Touch 24.04 to a Xiaomi Poco X3 Pro (vayu).
# Start with the phone in FASTBOOT mode (power off, then hold Vol- + Power).
#   ./flash.sh               full install (boot, dtbo, vbmeta, vendor, userdata)
#   ./flash.sh --rootfs-only only re-format /data and copy ubuntu.img
# WARNING: wipes all data on the phone.
set -e
cd "$(dirname "$0")/images"
MODE=${1:-full}

step() { echo; echo "==> $*"; }
wait_fastboot() { for i in $(seq 1 90); do fastboot devices | grep -q . && return 0; sleep 1; done; echo "no fastboot device"; exit 1; }
wait_recovery() { for i in $(seq 1 90); do adb devices | grep -q "recovery$" && return 0; sleep 1; done; echo "no adb recovery device"; exit 1; }

command -v fastboot >/dev/null && command -v adb >/dev/null || { echo "install android-tools (adb/fastboot) first"; exit 1; }
sha256sum -c ../SHA256SUMS --quiet

step "Waiting for phone in fastboot mode"
wait_fastboot
[ "$(fastboot getvar product 2>&1 | awk '/product:/{print $2}')" = vayu ] || { echo "not a vayu device"; exit 1; }
[ "$(fastboot getvar unlocked 2>&1 | awk '/unlocked:/{print $2}')" = yes ] || { echo "bootloader is locked"; exit 1; }

if [ "$MODE" != "--rootfs-only" ]; then
  step "Flashing boot, dtbo, vbmeta (bootloader fastboot)"
  fastboot flash boot boot.img
  fastboot flash dtbo dtbo.img
  fastboot --disable-verity --disable-verification flash vbmeta vbmeta.img

  step "Rebooting to fastbootd to flash vendor (dynamic partition)"
  fastboot reboot fastboot
  sleep 5; wait_fastboot
  [ "$(fastboot getvar is-userspace 2>&1 | awk '/is-userspace:/{print $2}')" = yes ] || { echo "not in fastbootd"; exit 1; }
  fastboot flash vendor vendor.img

  step "Back to bootloader"
  fastboot reboot bootloader
  sleep 5; wait_fastboot
fi

step "Temporarily booting OrangeFox recovery (not installed)"
fastboot boot orangefox-R11.3-vayu-recovery.img
wait_recovery; sleep 5

step "Formatting /data as ext4"
adb shell 'umount /data 2>/dev/null; umount /sdcard 2>/dev/null; true'
adb shell 'mke2fs -F -t ext4 /dev/block/by-name/userdata >/dev/null 2>&1 && echo ok'
adb shell 'mount -t ext4 /dev/block/by-name/userdata /data && df -h /data'

step "Copying ubuntu.img to /data (about 1 minute)"
adb push ubuntu.img /data/ubuntu.img
adb shell 'sync; umount /data'

step "Rebooting into Ubuntu Touch (first boot can take a few minutes)"
adb reboot
echo "Done."
