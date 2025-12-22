#!/bin/bash
set -euo pipefail

VERSION=24.10
ROUTER=192.168.8.1
PLATFORM=mediatek-mt7622
PROFILE=xiaomi_redmi-router-ax6s 

FILES=(
    /etc/config/dhcp
    /etc/config/dropbear
    /etc/config/dropbear-opkg
    /etc/config/firewall
    /etc/config/luci
    /etc/config/luci-opkg
    /etc/config/network
    /etc/config/nextdns
    /etc/config/rpcd
    /etc/config/system
    /etc/config/ubihealthd
    /etc/config/ubootenv
    /etc/config/uhttpd
    /etc/config/uhttpd-opkg
    /etc/config/wireless
    /etc/dropbear/authorized_keys
    /etc/dropbear/dropbear_ed25519_host_key
    /etc/dropbear/dropbear_rsa_host_key
    /etc/fw_env.config
    /etc/group
    /etc/hosts
    /etc/inittab
    /etc/luci-uploads/.placeholder
    /etc/nftables.d/10-custom-filter-chains.nft
    /etc/nftables.d/README
    /etc/opkg/keys/d310c6f2833e97f7
    /etc/passwd
    /etc/profile
    /etc/rc.local
    /etc/shadow
    /etc/shells
    /etc/shinit
    /etc/sysctl.conf
    /etc/uhttpd.crt
    /etc/uhttpd.key
)

# for file in "${FILES[@]}"; do
#   mkdir -p "files$(dirname "$file")"
#   scp "root@${ROUTER}:$file" "files$file"
# done

PACKAGES="$(ssh -o BatchMode=yes -o ConnectTimeout=5 root@${ROUTER} \
  "opkg list-installed | awk '{print \$1}' | xargs")"

echo "make image \\
  PROFILE=\"${PROFILE}\" \\
  PACKAGES=\"${PACKAGES}\" \\
  FILES=\"files\"" > build.sh && chmod +x build.sh

docker run --rm -it \
  -v ./files:/builder/files \
  -v ./build.sh:/builder/build.sh \
  -v ./bin:/builder/bin \
  openwrt/imagebuilder:${PLATFORM}-openwrt-${VERSION}

