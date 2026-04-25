#!/bin/bash
#=================================================
# Description: DIY script
# Lisence: MIT
# Author: eSirPlayground
# Youtube Channel: https://goo.gl/fvkdwm 
#=================================================
#1. Modify default IP
#sed -i 's/192.168.1.1/192.168.5.1/g' openwrt/package/base-files/files/bin/config_generate

set -e

RTP2HTTPD_REPO_URL="https://github.com/slipdaly/rtp2httpd.git"
RTP2HTTPD_REPO_BRANCH="stable_lite"
RTP2HTTPD_TMP_DIR="openwrt/package/_rtp2httpd_src"
RTP2HTTPD_PKG_DIR="openwrt/package/rtp2httpd-minimal"
LUCI_RTP2HTTPD_PKG_DIR="openwrt/package/luci-app-rtp2httpd-minimal"

rm -rf "${RTP2HTTPD_TMP_DIR}" "${RTP2HTTPD_PKG_DIR}" "${LUCI_RTP2HTTPD_PKG_DIR}"
git clone --depth 1 "${RTP2HTTPD_REPO_URL}" -b "${RTP2HTTPD_REPO_BRANCH}" "${RTP2HTTPD_TMP_DIR}"

cp -a "${RTP2HTTPD_TMP_DIR}/openwrt-support/rtp2httpd-minimal" "${RTP2HTTPD_PKG_DIR}"
cp -a "${RTP2HTTPD_TMP_DIR}/openwrt-support/luci-app-rtp2httpd-minimal" "${LUCI_RTP2HTTPD_PKG_DIR}"
rm -rf "${RTP2HTTPD_TMP_DIR}/.git"

RTP2HTTPD_SOURCE_REF='\$(TOPDIR)/package/_rtp2httpd_src'

if ! grep -q '^RTP2HTTPD_SOURCE_DIR:=' "${RTP2HTTPD_PKG_DIR}/Makefile"; then
  sed -i "/^PKG_NAME:=rtp2httpd-minimal$/a RTP2HTTPD_SOURCE_DIR:=${RTP2HTTPD_SOURCE_REF}" "${RTP2HTTPD_PKG_DIR}/Makefile"
else
  sed -i "s#^RTP2HTTPD_SOURCE_DIR:=.*#RTP2HTTPD_SOURCE_DIR:=${RTP2HTTPD_SOURCE_REF}#" "${RTP2HTTPD_PKG_DIR}/Makefile"
fi
sed -i 's#$(CURDIR)/\.\./\.\.#$(RTP2HTTPD_SOURCE_DIR)#g' "${RTP2HTTPD_PKG_DIR}/Makefile"

if ! grep -q '^RTP2HTTPD_SOURCE_DIR:=' "${LUCI_RTP2HTTPD_PKG_DIR}/Makefile"; then
  sed -i "/^LUCI_NAME:=luci-app-rtp2httpd-minimal$/a RTP2HTTPD_SOURCE_DIR:=${RTP2HTTPD_SOURCE_REF}" "${LUCI_RTP2HTTPD_PKG_DIR}/Makefile"
else
  sed -i "s#^RTP2HTTPD_SOURCE_DIR:=.*#RTP2HTTPD_SOURCE_DIR:=${RTP2HTTPD_SOURCE_REF}#" "${LUCI_RTP2HTTPD_PKG_DIR}/Makefile"
fi
sed -i 's#$(CURDIR)/\.\./\.\.#$(RTP2HTTPD_SOURCE_DIR)#g' "${LUCI_RTP2HTTPD_PKG_DIR}/Makefile"
