#!/bin/bash

#=================================================
# https://github.com/tete1030/openwrt-fastbuild-actions
# Description: FAST building OpenWrt with Github Actions and Docker!
# Lisence: MIT
# Author: Texot
#=================================================

set -eo pipefail

echo "Updating and installing feeds ..."
cd openwrt
[ "x${OPT_UPDATE_FEEDS}" != "x1" ] || ./scripts/feeds update -a
./scripts/feeds install -a

mkdir -p package/z-last-build-packages || true
cd package/z-last-build-packages

# install_package PACKAGE_DIR GIT_URL
install_package() {
  if (( $# != 2 )); then
    echo "Wrong arguments for install_package" >&2
    exit 1
  fi
  if [ -d "${1}" ]; then
    [ "x${OPT_UPDATE_FEEDS}" != "x1" ] || ( git -C "${1}" reset --hard && git -C "${1}" pull --ff )
  else
    git clone "${2}" "${1}"
  fi
}

# Customize here for any additional package you want to install/update
# Note that to have it compiled, you also have to set its CONFIG_* options
# Example:
# install_package mentohust https://github.com/KyleRicardo/MentoHUST-OpenWrt-ipk.git
install_package ATmaterial https://github.com/openwrt-develop/luci-theme-atmaterial.git
install_package serverchan https://github.com/KFERMercer/luci-app-serverchan.git
install_package Rosy https://github.com/rosywrt/luci-theme-rosy.git
install_package darkmatter https://github.com/apollo-ng/luci-theme-darkmatter.git
install_package purple https://github.com/rosywrt/luci-theme-purple.git
install_package luci-app-adguardhome https://github.com/rufengsuixing/luci-app-adguardhome.git
