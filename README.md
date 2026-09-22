# H3C Magic NX30 Pro 112M 大分区 ImmortalWrt 编译模板

目标：在 OpenWrt U-Boot 布局下把 `ubi` 分区从 64M 扩大到 112M，并将以下插件编进固件：

-Argon主题
#- `luci-app-openclash`
#- `luci-app-ddnsto`
- 中文语言包

## 使用方式

1. 把本目录上传到你的 GitHub 仓库。
2. 打开仓库的 `Actions` 页面。
3. 选择 `Build NX30 Pro 112M`，点 `Run workflow`。
4. 编译完成后在 `Artifacts` 里下载固件。

输出文件通常在：

```text
bin/targets/mediatek/filogic/
```

其中：

- `*h3c_magic-nx30-pro-112m-squashfs-sysupgrade.itb` 用于在已刷 OpenWrt U-Boot 的机器上直接升级。
- `*h3c_magic-nx30-pro-112m-initramfs-recovery.itb` 用于恢复环境。

## 刷入提醒

- 刷之前确认已有原厂分区备份。
- 本模板基于 `immortalwrt/immortalwrt` 的 `openwrt-24.10` 分支，不需要刷原厂 U-Boot。
