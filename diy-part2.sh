#!/usr/bin/env bash
set -Eeuo pipefail

# Fail early when the pinned OpenWrt revision no longer contains the OneCloud
# target expected by this repository.
test -f target/linux/amlogic/files/arch/arm/boot/dts/amlogic/meson8b-onecloud.dts
grep -q 'define Device/thunder-onecloud' target/linux/amlogic/image/meson8b.mk
test -f package/luci-app-openclash/Makefile

echo 'OneCloud target and OpenClash package are available.'
