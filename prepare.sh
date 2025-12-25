#!/bin/bash
set -euo pipefail

VERSION=24.10
ROUTER=192.168.8.1
OPENWRT_FILES=./files
PLATFORM=mediatek-mt7622
PROFILE=xiaomi_redmi-router-ax6s 

# Ensure local files repository exists and is empty
if [ -d ${OPENWRT_FILES} ]; then
	# Empty directory
	rm -rf ${OPENWRT_FILES}/*
else
	mkdir ${OPENWRT_FILES}
fi

# Stream files across
BACKUP_COMMAND="sysupgrade -b - -k" # Create tar archive and output to stdout
ssh root@${ROUTER} "${BACKUP_COMMAND}" | tar xzf - -C ${OPENWRT_FILES}

# Fixup /etc/dropbear permissions
if [ -d ${OPENWRT_FILES}/etc/dropbear ]; then
	chmod 755 ${OPENWRT_FILES}/etc/dropbear
fi

# Read list of installed packages
PACKAGES=$(awk -F '\t' '{print $1}' ./files/etc/backup/installed_packages.txt | tr '\n' ' ')

echo "make image \\
  PROFILE=\"${PROFILE}\" \\
  PACKAGES=\"${PACKAGES}\" \\
  FILES=\"${OPENWRT_FILES}\"" > build.sh && chmod +x build.sh

docker run --rm -it \
  -v ./files:/builder/files \
  -v ./build.sh:/builder/build.sh \
  -v ./bin:/builder/bin \
  openwrt/imagebuilder:${PLATFORM}-openwrt-${VERSION}

