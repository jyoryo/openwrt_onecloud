#!/usr/bin/env bash
set -Eeuo pipefail

# Fail early when the pinned OpenWrt revision no longer contains the OneCloud
# target expected by this repository.
test -f target/linux/amlogic/files/arch/arm/boot/dts/amlogic/meson8b-onecloud.dts
grep -q 'define Device/thunder-onecloud' target/linux/amlogic/image/meson8b.mk
test -f package/luci-app-openclash/Makefile
test -f feeds/passwall2/luci-app-passwall2/Makefile
test -f feeds/passwall_packages/xray-core/Makefile
test -f feeds/passwall_packages/sing-box/Makefile
grep -q "set network.lan.proto='dhcp'" files/etc/uci-defaults/99-onecloud-side-router
grep -q 'openwrt_passwall2' files/etc/uci-defaults/zzzz-onecloud-opkg
grep -q 'openwrt_passwall_packages' files/etc/uci-defaults/zzzz-onecloud-opkg
grep -q 'openwrt-passwall-build' files/etc/uci-defaults/zzzz-onecloud-opkg

echo 'OneCloud target, OpenClash, PassWall 2 and DHCP client defaults are available.'
