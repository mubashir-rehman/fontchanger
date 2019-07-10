#!/system/bin/sh
# Advanced Charging Controller (acc) Initializer
# Copyright (c) 2017-2019, VR25 (xda-developers)
# License: GPLv3+


if ! which busybox > /dev/null; then
  if [ -d /sbin/.magisk/busybox ]; then
    PATH=/sbin/.magisk/busybox:$PATH
  elif [ -d /sbin/.core/busybox ]; then
    PATH=/sbin/.core/busybox:$PATH
  else
    exit 3
  fi
fi

modId=$(sed -n 's/^id=//p' ${0%/*}/module.prop)

# prepare working directory
(
[ -d /sbin/.$modId ] && [[ ${1:-x} != -*o* ]] && exit 0
if ! mount -o remount,rw /sbin 2>/dev/null; then
  cp -a /sbin /dev/.sbin
  mount -o bind,rw /dev/.sbin /sbin
fi
mkdir -p /sbin/.$modId
[ -h /sbin/.$modId/$modId ] && rm /sbin/.$modId/$modId \
  || rm -rf /sbin/.$modId/$modId 2>/dev/null
[ ${MAGISK_VER_CODE:-18200} -gt 18100 ] \
  && ln -s ${0%/*} /sbin/.$modId/$modId \
  || cp -a ${0%/*} /sbin/.$modId/$modId
ln -fs /sbin/.$modId/$modId/$modId.sh /sbin/$modId
ln -fs /sbin/.$modId/$modId/$modId-functions.sh /sbin/$modId-functions

# fix termux's PATH
termuxSu=/data/data/com.termux/files/usr/bin/su
if [ -f $termuxSu ] && grep -q 'PATH=.*/sbin/su' $termuxSu; then
  sed '\|PATH=|s|/sbin/su|/sbin|' $termuxSu > $termuxSu.tmp
  cat $termuxSu.tmp > $termuxSu
  rm $termuxSu.tmp
fi
)

exit 0
