#!/bin/sh
set -e

cp -f dts/mt7981b-h3c-magic-nx30-pro-112m.dts \
    openwrt/target/linux/mediatek/dts/

cat >> openwrt/target/linux/mediatek/image/filogic.mk <<'EOF'

define Device/h3c_magic-nx30-pro-112m
  DEVICE_VENDOR := H3C
  DEVICE_MODEL := Magic NX30 Pro
  DEVICE_VARIANT := (112M OpenWrt U-Boot layout)
  DEVICE_DTS := mt7981b-h3c-magic-nx30-pro-112m
  DEVICE_DTS_DIR := ../dts
  UBINIZE_OPTS := -E 5
  BLOCKSIZE := 128k
  PAGESIZE := 2048
  KERNEL_IN_UBI := 1
  UBOOTENV_IN_UBI := 1
  IMAGE_SIZE := 110592k
  IMAGES := sysupgrade.itb
  KERNEL_INITRAMFS_SUFFIX := -recovery.itb
  KERNEL := kernel-bin | gzip
  KERNEL_INITRAMFS := kernel-bin | lzma | \
        fit lzma $$(KDIR)/image-$$(firstword $$(DEVICE_DTS)).dtb with-initrd | pad-to 64k
  IMAGE/sysupgrade.itb := append-kernel | \
        fit gzip $$(KDIR)/image-$$(firstword $$(DEVICE_DTS)).dtb external-static-with-rootfs | append-metadata
  DEVICE_PACKAGES := kmod-mt7915e kmod-mt7981-firmware mt7981-wo-firmware
  #DEVICE_PACKAGES := kmod-conninfra kmod-mt_wifi kmod-warp wifi-profile luci-app-mtwifi luci-app-turboacc-mtk
endef
TARGET_DEVICES += h3c_magic-nx30-pro-112m
EOF

# 1. 彻底删除开源 mt76 驱动源码，防止包名冲突
rm -rf openwrt/package/kernel/mt76

# 2. 克隆 padavanonly 的 MTK 闭源无线驱动组件到 package/mtk 目录
git clone --depth=1 https://github.com/padavanonly/immortalwrt-mt798x-6.6 -b openwrt-24.10-6.6 /tmp/immortalwrt-mt798x
mkdir -p openwrt/package/mtk
cp -r /tmp/immortalwrt-mt798x/package/mtk/* openwrt/package/mtk/
rm -rf /tmp/immortalwrt-mt798x

#3. 将默认IP修改为192.168.100.1
sed -i 's/192.168.1.1/192.168.100.1/g' openwrt/package/base-files/files/bin/config_generate

# 4. 添加 Nikki 官方软件源
echo 'src-git nikki https://github.com/nikkinikki-org/OpenWrt-nikki.git;main' >> openwrt/feeds.conf.default

# 5. 添加 PassWall 2 官方源（通过 feeds 机制拉取，会自动匹配系统依赖）
echo 'src-git passwall_dep https://github.com/Openwrt-Passwall/openwrt-passwall-packages.git;main' >> openwrt/feeds.conf.default
echo 'src-git passwall2 https://github.com/Openwrt-Passwall/openwrt-passwall2.git;main' >> openwrt/feeds.conf.default

# 6. 添加luci-adguardhome软件源
echo 'src-git adguardhome https://github.com/kenzok8/openwrt-packages.git;master' >> openwrt/feeds.conf.default



#cat >> openwrt/feeds.conf.default <<'EOF'
#src-git openclash https://github.com/vernesong/OpenClash.git
#src-git ddnsto https://github.com/linkease/ddnsto-openwrt.git
#EOF
