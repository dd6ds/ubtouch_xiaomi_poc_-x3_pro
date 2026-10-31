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

## Hardware support

Tested on 2026-10-28 with this kit (UT 24.04-2.2 stable) on a Poco X3 Pro (MIUI 12.5.5 EEA firmware base).

| Function | Status |
|---|---|
| Wi-Fi | ✅ WORKS |
| Bluetooth | ✅ WORKS |
| Camera | ✅ WORKS |
| Sound | ✅ WORKS |
| Battery charging | ✅ WORKS |
| Airplane mode | ✅ WORKS |
| Hotspot | ✅ WORKS |
| GPS | ✅ WORKS |
| Mobile network / phone calls | ✅ WORKS |
| Torchlight | ✅ WORKS |
| Switching between cameras | ✅ WORKS |
| Video | ✅ WORKS |
| Data connection | ✅ WORKS |
| PIN unlock | ✅ WORKS |
| Volume control in calls | ✅ WORKS |
| Battery percentage | ✅ WORKS |
| Offline charging | ✅ WORKS |
| SD card storage | ✅ WORKS |
| Shutdown / Reboot | ✅ WORKS |

### Screenshots

<table>
<tr><td align="center"><img src="screenshots/sysinfo.png" width="220" alt="System info"><br><sub>System info</sub></td><td align="center"><img src="screenshots/wifi-mobile.png" width="220" alt="Wi-Fi + mobile network"><br><sub>Wi-Fi + mobile network</sub></td><td align="center"><img src="screenshots/bluetooth.png" width="220" alt="Bluetooth (MeshCore node found)"><br><sub>Bluetooth (MeshCore node found)</sub></td></tr>
<tr><td align="center"><img src="screenshots/battery.png" width="220" alt="Battery / charging"><br><sub>Battery / charging</sub></td><td align="center"><img src="screenshots/camera.png" width="220" alt="Camera"><br><sub>Camera</sub></td><td align="center"><img src="screenshots/hotspot.png" width="220" alt="Hotspot"><br><sub>Hotspot</sub></td></tr>
<tr><td align="center"><img src="screenshots/hotspot-setup.png" width="220" alt="Hotspot setup"><br><sub>Hotspot setup</sub></td><td align="center"><img src="screenshots/location.png" width="220" alt="Location"><br><sub>Location</sub></td><td align="center"><img src="screenshots/location-settings.png" width="220" alt="Location settings (GPS)"><br><sub>Location settings (GPS)</sub></td></tr>
</table>

<details><summary>Full feature matrix (layout of devices.ubuntu-touch.io)</summary>

✅ = works · ❔ = not tested yet

| Category | Feature | Status |
|---|---|---|
| Actors | Manual brightness | ❔ |
|  | Notification LED | ❔ |
|  | Torchlight | ✅ |
|  | Vibration | ❔ |
| Camera | Flashlight | ❔ |
|  | Photo | ✅ |
|  | Switching between cameras | ✅ |
|  | Video | ✅ |
| Cellular | Change audio routings | ❔ |
|  | Incoming, outgoing calls | ✅ |
|  | Carrier info, signal strength | ✅ |
|  | Data connection | ✅ |
|  | Dual SIM functionality | ❔ |
|  | MMS in, out | ❔ |
|  | PIN unlock | ✅ |
|  | SMS in, out | ❔ |
|  | Voice in calls | ✅ |
|  | LTE calling (VoLTE) | ❔ |
|  | Volume control in calls | ✅ |
| Endurance | 24+ hours battery lifetime | ❔ |
|  | 7+ days stability | ❔ |
| GPU | Boot into UI | ✅ |
|  | Hardware video playback | ❔ |
| Misc | AppArmor patches | ❔ |
|  | Battery percentage | ✅ |
|  | Reset to factory defaults | ❔ |
|  | Offline charging | ✅ |
|  | Online charging | ✅ |
|  | Recovery image | ❔ |
|  | RTC time | ❔ |
|  | SD card storage | ✅ |
|  | Shutdown / Reboot | ✅ |
|  | Waydroid | ❔ |
|  | Wireless External monitor | ❔ |
| Network | Bluetooth | ✅ |
|  | Flight mode | ✅ |
|  | Hotspot | ✅ |
|  | NFC | ❔ |
|  | WiFi | ✅ |
| Sensors | Automatic brightness | ❔ |
|  | Double touch to wake | ❔ |
|  | Fingerprint reader | ❔ |
|  | GPS | ✅ |
|  | Proximity | ❔ |
|  | Rotation | ❔ |
|  | Touchscreen | ✅ |
| Sound | Earphones | ❔ |
|  | Loudspeaker | ✅ |
|  | Microphone | ✅ |
|  | Volume control | ✅ |
| USB | ADB access | ❔ |
|  | MTP access | ❔ |

</details>

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
screenshots/              screenshots taken on the device
build/
  build-2404.sh           downloads + builds the complete kit, no root needed
  out/device_vayu_usrmerge.tar.xz
```

## Requirements & installation notes

Go through this list before you start – most failed installs come from a missing item here.

### Phone

- **Poco X3 Pro, codename `vayu`** (global/EEA model M2102J20SG). `flash.sh` aborts unless `fastboot getvar product` reports `vayu`.
- **Firmware base MIUI 12.5.x / Android 11** (check under *Settings → About phone*). Tested on MIUI 12.5.5 EEA.
  The kit only replaces boot, dtbo, vbmeta and vendor – the phone's own firmware partitions (modem, DSP, …) stay
  and have to match Halium 11. If the phone already runs MIUI 13/14 (Android 12/13), first flash a MIUI 12.5
  fastboot ROM for vayu with Xiaomi's `flash_all.sh`. Check `fastboot getvar anti` beforehand and never flash a ROM
  with a lower anti-rollback index than the phone reports.
- **Unlocked bootloader** (step 1) – plan for Xiaomi's waiting time of **168 hours (7 days)**.
- **Xiaomi account with a phone number** and a **SIM card with mobile data** to bind the account (step 1.1).
- **Battery at least 50 %** – the phone switches between bootloader, fastbootd and recovery and must not run out.
- **Back up everything**: unlocking and flashing wipe the internal storage completely.
  A microSD card is not touched, but remove it to be safe.

### Linux PC

- Linux with bash (developed on Linux Mint 22). `flash.sh` does not run on Windows; macOS is untested.
- Packages:

  | Distribution | Command |
  |---|---|
  | Debian / Ubuntu / Linux Mint | `sudo apt install adb fastboot android-sdk-platform-tools-common python3 python3-venv zstd` |
  | Fedora | `sudo dnf install android-tools python3 zstd` |
  | Arch / Manjaro | `sudo pacman -S android-tools android-udev python zstd` |

  `zstd` is only needed to unpack the `.tar.zst` release archive.
- **`fastboot` version 31 or newer** (`fastboot --version`) – older versions cannot switch to fastbootd
  (`fastboot reboot fastboot`), which is needed for `vendor.img`. If your distribution ships an older one, download
  Google's *SDK Platform-Tools* for Linux, unpack them and put them first in `PATH`:
  `export PATH="$HOME/platform-tools:$PATH"`.
- **USB permissions**: without a udev rule `fastboot devices` shows `no permissions`. The packages above
  (`android-sdk-platform-tools-common` / `android-udev`) install suitable rules. Otherwise create
  `/etc/udev/rules.d/51-android.rules`:

  ```
  SUBSYSTEM=="usb", ATTR{idVendor}=="2717", MODE="0660", TAG+="uaccess"
  SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", MODE="0660", TAG+="uaccess"
  ```

  then `sudo udevadm control --reload-rules && sudo udevadm trigger` and re-plug the phone.
- **USB cable / port**: a data cable, connected directly to the PC (no hub). If fastboot hangs or reports
  `FAILED (Status read failed)`, try a USB 2.0 port – the Xiaomi bootloader is picky with some USB 3 controllers.
- **Disk space**: about 6 GB for the unpacked kit, about 16 GB for a rebuild (see below).

### Pre-flight check

```bash
cd vayu-ubuntu-touch-24.04-flashkit
fastboot --version                       # 31 or newer
(cd images && sha256sum -c ../SHA256SUMS) # every line: OK
# phone in fastboot mode (power off, hold Vol- + Power), connected via USB:
fastboot devices                         # <serial>  fastboot
fastboot getvar product                  # product: vayu
fastboot getvar unlocked                 # unlocked: yes  (after step 1)
fastboot getvar anti                     # note the anti-rollback index
```

Time needed: unlocking up to 7 days (waiting time), flashing about 10 minutes, first boot 1–3 minutes.

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
See [Hardware support](#hardware-support) for what has been tested.

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
| `no permissions` in `fastboot devices` | udev rule missing (see [Requirements](#requirements--installation-notes)), re-plug the phone |
| `fastboot reboot fastboot` fails / stays in bootloader | `fastboot` too old – use Google's current platform-tools (version 31+) |
| fastboot hangs / `FAILED (Status read failed)` | USB 2.0 port, no hub, different cable |
| miunlock `20041` | no phone number on the Xiaomi account (see 1.1) |
| miunlock `20036` | waiting time – do not re-add the account |
| `Partition not found` (vendor) | flash vendor from fastbootd (`fastboot reboot fastboot`) |
| boot loop / back to fastboot | re-check boot.img + dtbo.img, re-run `./flash.sh` |
| Back to Android | flash a MIUI fastboot ROM for vayu with Xiaomi's `flash_all.sh` (not `flash_all_lock`!) |

## Credits

UBports, the vayu community porters (Verevka et al.), Droidian vayu team (`droidian-vayu` on GitHub),
OrangeFox Recovery, offici5l/MiUnlockTool (`miunlock`).
