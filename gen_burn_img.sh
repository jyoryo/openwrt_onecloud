#!/usr/bin/env bash
set -Eeuo pipefail
shopt -s nullglob

workspace="${GITHUB_WORKSPACE:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"
target_dir="${workspace}/openwrt/bin/targets/amlogic/meson8b"
amlimg="${workspace}/AmlImg"
uboot_image="${workspace}/uboot.img"
temp_dir="$(mktemp -d)"
burn_dir="${temp_dir}/burn"
loop_device=''

cleanup() {
  if [[ -n "${loop_device}" ]]; then
    sudo losetup -d "${loop_device}" >/dev/null 2>&1 || true
  fi
  rm -rf "${temp_dir}"
}
trap cleanup EXIT

compressed_images=("${target_dir}"/*thunder-onecloud*ext4*emmc.img.gz)
if [[ ${#compressed_images[@]} -ne 1 ]]; then
  echo "Expected exactly one compressed OneCloud eMMC image, found ${#compressed_images[@]}." >&2
  exit 1
fi

test -x "${amlimg}"
test -f "${uboot_image}"
command -v img2simg >/dev/null

source_image="${compressed_images[0]}"
raw_image="${temp_dir}/onecloud-emmc.img"
output_prefix="${source_image%.img.gz}"
burn_image="${output_prefix}.burn.img"

gzip -dc "${source_image}" > "${raw_image}"
"${amlimg}" unpack "${uboot_image}" "${burn_dir}"

loop_device="$(sudo losetup --find --show --partscan "${raw_image}")"
test -b "${loop_device}p1"
test -b "${loop_device}p2"

sudo img2simg "${loop_device}p1" "${burn_dir}/boot.simg"
sudo img2simg "${loop_device}p2" "${burn_dir}/rootfs.simg"
sudo chown "$(id -u):$(id -g)" "${burn_dir}/boot.simg" "${burn_dir}/rootfs.simg"

sudo losetup -d "${loop_device}"
loop_device=''

printf '%s\n' \
  'PARTITION:boot:sparse:boot.simg' \
  'PARTITION:rootfs:sparse:rootfs.simg' >> "${burn_dir}/commands.txt"

"${amlimg}" pack "${burn_image}" "${burn_dir}"
xz -T0 -6 --force "${burn_image}"
sha256sum "${burn_image}.xz" > "${burn_image}.xz.sha256"

echo "Burn image: ${burn_image}.xz"
