# Ubuntu Touch 24.04 for Xiaomi Poco X3 Pro (vayu) – Flash Kit

*Deutsche Version: [README.de.md](README.de.md)*

Unofficial Ubuntu Touch image for the Poco X3 Pro (codename **vayu**), built from:

| Part | Source |
|---|---|
| Rootfs | UBports **24.04-2.2 stable** (Ubuntu 24.04.5 LTS), from system-image.ubports.com |
| Kernel / boot.img / dtbo.img / device overlay | Community port `ubports/porting/community-ports/android11/xiaomi-poco-x3-pro/xiaomi-vayu` (CI build 2026-10-19) |
| Halium | Halium 11 generic arm64 (UBports Jenkins) |
| vendor.img / vbmeta.img | Droidian vayu snapshot 2024-11-18 (MIUI vendor with Linux fixes) |
| Recovery | OrangeFox R11.3 stable for vayu (only booted temporarily, never installed) |

> ⚠️ This is **not** an official UBports release and the device is **not** in the UBports installer.
> Flashing wipes **all data** on the phone. Use at your own risk.

## Contents

```
flash.sh                  automated flashing script (Linux)
SHA256SUMS                checksums of the images
images/
  boot.img                UT kernel + halium initramfs
  dtbo.img                device tree overlay (matches the kernel)
  vbmeta.img              flashed with verification disabled
  vendor.img              Droidian vayu vendor
  orangefox-R11.3-vayu-recovery.img
  ubuntu.img              Ubuntu Touch 24.04 rootfs (copied to /data)
build/
  build-2404.sh           downloads + builds the complete kit, no root needed
  out/device_vayu_usrmerge.tar.xz
```

## Requirements

- Poco X3 Pro (vayu) running **MIUI 12.5.x / Android 11** (firmware base for Halium 11). Tested on MIUI 12.5.5 EEA.
- Linux PC with `adb`, `fastboot` (android-tools / `android-sdk-platform-tools`), `python3`, `python3-venv`.
- A good USB data cable.
- About 6 GB free disk space.

---

## Step 1 – Unlock the bootloader (with miunlock in a Python venv)

Xiaomi's official Mi Unlock tool is Windows-only; **miunlock** is a Python reimplementation that works on Linux.

### 1.1 Prepare the Xiaomi account and the phone

1. The Xiaomi account **must have a phone number** attached, otherwise miunlock fails with
   `code 20041: your MI ID is not associated with a phone number`.
   Accounts that were created via *Sign in with Google* often have no phone number/password –
   in that case create a new Xiaomi account **registered with a phone number**.
2. On the phone: **Settings → About phone → All specs → tap "MIUI version" 7×** to enable developer mode
   (not "Kernel version" – that opens the CIT test menu).
3. **Settings → Additional settings → Developer options**:
   - enable **OEM unlocking** and **USB debugging**
   - sign in with the Xiaomi account (Settings → Mi Account)
4. Insert a **SIM card**, switch **Wi-Fi off** and **mobile data on**, then
   **Developer options → Mi Unlock status → Add account and device**. Wait for "Added successfully".
   The SIM can be removed afterwards.

### 1.2 Install miunlock in a venv

```bash
python3 -m venv ~/poco_X3_pro
source ~/poco_X3_pro/bin/activate
pip install miunlock          # no --user inside a venv!
```

### 1.3 Unlock

```bash
source ~/poco_X3_pro/bin/activate
adb reboot bootloader         # or: power off, hold Vol- + Power
fastboot devices              # must show the device
miunlock                      # log in with the SAME Xiaomi account
```

- First run usually returns `code 20036: Please unlock 168 hours later`.
  **Wait the full time (7 days) and do NOT add the account in Mi Unlock status again** – that restarts the timer.
- If miunlock prints a `notificationUrl`, open it in a browser, confirm your identity (SMS), then run miunlock again.
- After the waiting time run `miunlock` again; it fetches the signed token and unlocks the bootloader
  (if asked, run `fastboot oem unlock`). **The phone is wiped.**
- Check: `fastboot getvar unlocked` → `unlocked: yes`.

Useful checks: `fastboot getvar product` → `vayu`, `fastboot getvar anti` (anti-rollback index – never flash firmware older than it allows).

---

## Step 2 – Flash Ubuntu Touch

### 2a. Automatic

```bash
cd vayu-ubuntu-touch-24.04-flashkit
# phone in FASTBOOT mode (power off, hold Vol- + Power), connected via USB
./flash.sh
```

The script verifies checksums and the device, flashes everything, temporarily boots OrangeFox,
formats `/data` as ext4, copies `ubuntu.img` and reboots.
`./flash.sh --rootfs-only` only re-formats `/data` and copies a new `ubuntu.img` (e.g. after a rebuild).

### 2b. Manual

```bash
cd images
# bootloader fastboot
fastboot flash boot boot.img
fastboot flash dtbo dtbo.img
fastboot --disable-verity --disable-verification flash vbmeta vbmeta.img

# vendor lives in the dynamic "super" partition -> needs fastbootd
fastboot reboot fastboot
fastboot getvar is-userspace          # must say: yes
fastboot flash vendor vendor.img

# boot OrangeFox temporarily
fastboot reboot bootloader
fastboot boot orangefox-R11.3-vayu-recovery.img

# in OrangeFox (adb shows "recovery"):
adb shell 'umount /data; umount /sdcard; mke2fs -F -t ext4 /dev/block/by-name/userdata'
adb shell 'mount -t ext4 /dev/block/by-name/userdata /data'
adb push ubuntu.img /data/ubuntu.img
adb shell 'sync; umount /data'
adb reboot
```

Notes:
- `fastboot flash vendor` in the normal bootloader fails with `Partition not found` – use fastbootd.
- `/data` is formatted as **ext4** (OrangeFox's "Format data" creates f2fs).
- MIUI 12.5.9 is **not** required; any MIUI 12.5 (Android 11) firmware works.

## Step 3 – First boot

The first boot takes 1–3 minutes, then the Ubuntu Touch welcome wizard appears.
Hardware support of this 24.04 build has not been fully tested yet – please check Wi-Fi, mobile data,
calls, audio, Bluetooth, camera, GPS and sensors.

## Rebuilding the whole kit

A single script downloads and builds **everything** – it also works on its own, outside the kit:

```bash
./build/build-2404.sh          # -> ./build/vayu-ubuntu-touch-24.04-flashkit/
./build/build-2404.sh --pack   # additionally creates the .tar.zst + .sha256
```

Needs `curl wget python3 unzip fakeroot e2fsprogs (mke2fs >= 1.43) xz-utils` (`zstd` for `--pack`)
and about **16 GB** free disk space. **No root/sudo needed** (fakeroot + `mke2fs -d`).
Downloads are cached in `dl/` next to the script, so a second run is much faster.

What it does:
1. latest successful CI build of the vayu port (kernel, `boot.img`, `dtbo.img`, device overlay) –
   skipped if `out/device_vayu_usrmerge.tar.xz` already exists next to the script
   (GitLab deletes CI artifacts after ~30 days, so keep that file!)
2. current UBports **24.04-2.x stable** rootfs from system-image.ubports.com
3. Halium 11 generic arm64
4. Droidian vayu image (~2 GB, checksum verified) → `vendor.img`, `vbmeta.img`
5. OrangeFox R11.3 for vayu (checksum verified) → recovery image
6. builds `ubuntu.img`, writes `flash.sh`, `SHA256SUMS` and these READMEs

Then flash with `./flash.sh` (new install) or `./flash.sh --rootfs-only` (only a new `ubuntu.img`).

## Troubleshooting

| Problem | Fix |
|---|---|
| `adb: no devices` | enable USB debugging, accept the prompt, try another cable; udev rule for vendor `2717`/`18d1` |
| miunlock `20041` | no phone number on the Xiaomi account (see 1.1) |
| miunlock `20036` | waiting time – do not re-add the account |
| `Partition not found` (vendor) | flash vendor from fastbootd (`fastboot reboot fastboot`) |
| boot loop / back to fastboot | re-check boot.img + dtbo.img, re-run `./flash.sh` |
| Back to Android | flash a MIUI fastboot ROM for vayu with Xiaomi's `flash_all.sh` (not `flash_all_lock`!) |

## Credits

UBports, the vayu community porters (Verevka et al.), Droidian vayu team (`droidian-vayu` on GitHub),
OrangeFox Recovery, offici5l/MiUnlockTool (`miunlock`).
