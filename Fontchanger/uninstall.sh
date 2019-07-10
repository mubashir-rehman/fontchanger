#!/system/bin/sh

if ! which busybox > /dev/null; then
  if [ -d /sbin/.magisk/busybox ]; then
    PATH=/sbin/.magisk/busybox:$PATH
  elif [ -d /sbin/.core/busybox ]; then
    PATH=/sbin/.core/busybox:$PATH
  else
    echo "(!) Install busybox binary first"
    exit 3
  fi
fi

pgrep -f '/acc (-|--)[def]|/accd.sh' | xargs kill 2>/dev/null
set -e
rm -rf $(readlink -f ${0%/*})
