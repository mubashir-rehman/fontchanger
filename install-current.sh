#!/system/bin/sh
set +x
# From-source Installer/Upgrader
# Copyright (c) 2019, VR25 (xda-developers.com)
# License: GPLv3+

set_perm() {
  chown $2:$3 $1 || return 1
  chmod $4 $1 || return 1
  CON=$5
  [ -z $CON ] && CON=u:object_r:system_file:s0
  chcon $CON $1 || return 1
}

set_perm_recursive() {
  find $1 -type d 2>/dev/null | while read dir; do
    set_perm $dir $2 $3 $4 $6
  done
  find $1 -type f -o -type l 2>/dev/null | while read file; do
    set_perm $file $2 $3 $5 $6
  done
}


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

# Detect root
_name=$(basename $0)
ls /data >/dev/null 2>&1 || { echo "$MODID needs to run as root!"; echo "type 'su' then '$_name'"; quit 1; }

if [ -f /data/adb/magisk/util_functions.sh ]; then
  . /data/adb/magisk/util_functions.sh
elif [ -f /data/magisk/util_functions.sh ]; then
  . /data/magisk/util_functions.sh
else
  echo "! Can't find magisk util_functions! Aborting!"; exit 1
fi

print() { sed -n "s|^$1=||p" ${2:-$srcDir/module.prop}; }

api_level_arch_detect
[ -f $PWD/${0##*/} ] && srcDir=$PWD || srcDir=${0%/*}
modId=$(print id)
name=$(print name)
author=$(print author)
version=$(print version)
versionCode=$(print versionCode)
date=$(print date)
installDir=/data/adb/modules

[ -d $installDir ] || installDir=/sbin/.core/img
[ -d $installDir ] || installDir=/sbin/.magisk/modules
[ -d $installDir ] || { echo "(!) /data/adb/ not found\n"; exit 1; }


cat << CAT
$name $version $date
Copyright (c) 2019, $author
License: GPLv3+

(i) Installing to $installDir/$modId/...
CAT

installDir=$installDir/$modId
cp -f $srcDir/module.prop $installDir
cp -f $srcDir/${modId}-functions.sh $installDir
if [ ! -d $installDir/system/bin ]; then
  mkdir -p $installDir/system/bin
  cp -f $srcDir/system/bin/font_changer.sh $installDir/system/bin/font_changer
else
  cp -f $srcDir/system/bin/font_changer.sh $installDir/system/bin/font_changer
fi
mkdir -p /storage/emulated/0/Fontchanger/Fonts/Custom
mkdir -p /storage/emulated/0/Fontchanger/Emojis/Custom
cp -f $srcDir/README.md $installDir
cp -f $srcDir/common/curl-$ARCH32 $installDir/curl
cp -f $srcDir/common/sleep-$ARCH32 $installDir/sleep

set_perm_recursive $installDir 0 0 0755 0644
set_perm $installDir/system/bin/font_changer 0 0 0755
set_perm $installDir/functions.sh 0 0 0755
set_perm $installDir/curl 0 0 0755
set_perm $installDir/sleep 0 0 0755

$installDir/curl -k -o /storage/emulated/0/Fontchanger/fonts-list.txt https://john-fawkes.com/Downloads/fontlist/fonts-list.txt
$installDir/curl -k -o /storage/emulated/0/Fontchanger/emojis-list.txt https://john-fawkes.com/Downloads/emojilist/emojis-list.txt

exit 0
