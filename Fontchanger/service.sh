#!/system/bin/sh

# Do NOT assume where your module will be located.
# ALWAYS use $MODDIR if you need to know where this script
# and module is placed.
# This will make sure your module will still work
# if Magisk change its mount point in the future

get_file_value() {
  if [ -f "$1" ]; then
    grep $2 $1 | sed "s|.*${2}||" | sed 's|\"||g'
  fi
} 

set +x
MODID=Fontchanger
MAGISK_VER_CODE="$(echo $(get_file_value /data/adb/magisk/util_functions.sh MAGISK_VER_CODE) | sed 's|-.*||')"
FCDIR=/storage/emulated/0/Fontchanger
TMPLOGLOC=$FCDIR/logs
umask 077

# log
mkdir -p $TMPLOGLOC
exec > $TMPLOGLOC 2>&1
set -x

[ -f $PWD/${0##*/} ] && MODPATH=$PWD || MODPATH=${0%/*}
. $MODPATH/busybox.sh

# prepare working directory
([ -d /sbin/.$MODID ] && [[ ${1:-x} != -*o* ]] && exit 0
if ! mount -o remount,rw /sbin 2>/dev/null; then
  cp -a /sbin /dev/.sbin
  mount -o bind,rw /dev/.sbin /sbin
  restorecon -R /sbin > /dev/null 2>&1
fi

mkdir -p /sbin/.$MODID
[ -h /sbin/.$MODID/$MODID ] && rm /sbin/.$MODID/$MODID \
  || rm -rf /sbin/.$MODID/$MODID 2>/dev/null
[ ${MAGISK_VER_CODE} -gt 18100 ] \
  && ln -s $MODPATH /sbin/.$MODID/$MODID \
  || cp -a $MODPATH /sbin/.$MODID/$MODID

ln -fs /sbin/.$MODID/$MODID/font_changer.sh /sbin/font_changer
ln -fs /sbin/.$MODID/$MODID/${MODID}-functions.sh /sbin/${MODID}-functions ) &

# fix termux's PATH
termuxSu=/data/data/com.termux/files/usr/bin/su
if [ -f $termuxSu ] && grep -q 'PATH=.*/sbin/su' $termuxSu; then
  sed '\|PATH=|s|/sbin/su|/sbin|' $termuxSu > $termuxSu.tmp
  cat $termuxSu.tmp > $termuxSu
  rm $termuxSu.tmp
fi

exit 0