#!/system/bin/sh
# From-source Installer/Upgrader
# Copyright (c) 2019, VR25 (xda-developers.com)
# License: GPLv3+


echo
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

if [ -f /data/adb/magisk/util_functions.sh ]; then
  . /data/adb/magisk/util_functions.sh
elif [ -f /data/magisk/util_functions.sh ]; then
  . /data/magisk/util_functions.sh
else
  echo "! Can't find magisk util_functions! Aborting!"; exit 1
fi

print() { sed -n "s|^$1=||p" ${2:-$srcDir/module.prop}; }

umask 022
set -euo pipefail

[ -f $PWD/${0##*/} ] && srcDir=$PWD || srcDir=${0%/*}
modId=$(print id)
name=$(print name)
author=$(print author)
version=$(print version)
versionCode=$(print versionCode)
installDir=/sbin/.magisk/modules

[ -d $installDir ] || installDir=/sbin/.core/img
[ -d $installDir ] || installDir=/data/adb
[ -d $installDir ] || { echo "(!) /data/adb/ not found\n"; exit 1; }


cat << CAT
$name $version
Copyright (c) 2019, $author
License: GPLv3+

(i) Installing to $installDir/$modId/...
CAT

rm -rf $installDir/${modId:-_PLACEHOLDER_} 2>/dev/null
cp -R $srcDir/$modId/ $installDir/
installDir=$installDir/$modId
cp $srcDir/module.prop $installDir/
<<<<<<< HEAD
=======
mkdir -p /storage/emulated/0/Fontchanger/Fonts/Custom
mkdir -P /storage/emulated/0/Fontchanger/Emojis/Custom
>>>>>>> b37f54b413b140f7639e711d008a35bcb96ae8ff

cp -f $srcDir/curl-$ARCH32 $installDir/curl
cp -f $srcDir/sleep-$ARCH32 $installDir/sleep
cp -f $srcDir/common/functions.sh $installDir/functions.sh

set_perm_recursive $installDir 0 0 0755 0644
set_perm $installDir/system/bin/font_changer 0 2000 0755
<<<<<<< HEAD
=======
set_perm $installDir/functions.sh 0 2000 0755
>>>>>>> b37f54b413b140f7639e711d008a35bcb96ae8ff
set_perm $installDir/curl 0 2000 0755
set_perm $installDir/sleep 0 2000 0755

$installDir/curl-$ARCH32 -k -o /storage/emulated/0/Fontchanger/fonts-list.txt https://john-fawkes.com/Downloads/fontlist/fonts-list.txt
$installDir/curl-$ARCH32 -k -o /storage/emulated/0/Fontchanger/emojis-list.txt https://john-fawkes.com/Downloads/emojilist/emojis-list.txt

set +euo pipefail

echo
trap - EXIT

e=$?
[ $e -eq 0 ] || { echo; exit $e; }
exit 0
