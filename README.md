# OneCloud OpenWrt

用于编译玩客云 S805 的 OpenWrt 单网口旁路由固件，仅保留 LuCI、
firewall4、OpenClash 和 WireGuard 所需组件。

## 默认网络

- 管理地址：由主路由 DHCP 自动分配
- 网关和 DNS：通过 DHCP 自动获取
- 本机 DHCP/DHCPv6/RA 服务：关闭
- 主机名：`OneCloud`

首次启动后，请在主路由的 DHCP 客户端列表中找到主机名 `OneCloud`，再按
它的 MAC 地址设置静态租约。需要使用代理的客户端应把网关和 DNS 设置为
该保留地址；其他客户端继续使用主路由的IP，不会经过旁路由。

固件不预设 root 密码。首次登录后请立即设置密码。

## 构建

在 GitHub Actions 中手动运行 `Build OneCloud OpenWrt`。构建固定版本的
`coolsnowwolf/lede`、必要 feeds 和 `vernesong/OpenClash`，成功后同时产生
普通 eMMC 镜像和文件名包含 `.burn.img.xz` 的 Amlogic USB Burning Tool
线刷镜像。

OpenClash 的 Mihomo ARMv7 内核暂不预置。刷机后可在 LuCI 的 OpenClash
页面下载或更新内核；后续可再将经过校验的固定版本内核加入固件。

固件内置 WireGuard 内核模块、`wg` 命令和 LuCI 协议支持。刷机后可在
“网络 → 接口”中新增 WireGuard 接口；固件不预置任何密钥或隧道配置。

## 刷机提示

`.burn.img.xz` 解压后可供 Amlogic USB Burning Tool 使用。刷机有导致设备
无法启动或数据丢失的风险，请确认设备型号并提前备份。

## 来源

- OpenWrt 源码：https://github.com/coolsnowwolf/lede
- OpenClash：https://github.com/vernesong/OpenClash
- OneCloud 参考：https://github.com/xydche/onecloud-openwrt
- OneCloud 参考：https://github.com/shiyu1314/openwrt-onecloud
- U-Boot：https://github.com/hzyitc/u-boot-onecloud
- AmlImg：https://github.com/hzyitc/AmlImg
