#!/system/bin/sh
#
# $modId installer/upgrader
# https://raw.githubusercontent.com/VR-25/$modId/master/install-latest.sh
#
# Copyright (C) 2019, VR25 @xda-developers
# License: GPLv3+
#
# Run "which $modId > /dev/null || sh <this script>" to install $modId.


echo
MODID=fontchanger
trap 'e=$?; echo; exit $e' EXIT

if ! which busybox > /dev/null; then
  if [ -d /sbin/.magisk/busybox ]; then
    PATH=/sbin/.magisk/busybox:$PATH
  elif [ -d /sbin/.core/busybox ]; then
    PATH=/sbin/.core/busybox:$PATH
  else
    echo "(!) Install busybox binary first"
    exit 1
  fi
fi

if [ $(id -u) -ne 0 ]; then
  echo "(!) $0 must run as root (su)"
  exit 1
fi

set -euo pipefail
get_ver() { sed -n 's/^version=//p' ${1:-}; }

instVer=$(get_ver /sbin/.magisk/modules/$MODID/module.prop 2>/dev/null || :)
currVer=$(wget https://raw.githubusercontent.com/johnfawkes/$MODID/master/module.prop --output-document - | get_ver)
num=$((instVer+1))
tarball=https://github.com/johnfawkes/$MODID/archive/$num.tar.gz

set +euo pipefail

if [ ${instVer:-0} -lt ${currVer:-0} ] \
  && echo && wget $tarball --output-document - | tar -xz
then
  echo
  trap - EXIT
  sh ${MODID}-${1:-master}/install-current.sh
else
  echo
  echo "(i) No update available"
fi

exit 0
