SDCARD=/storage/emulated/0
FCDIR=$SDCARD/Fontchanger

get_ver() { sed -n 's/^date=//p' ${1:-}; }

updater() {
instVer=$(get_ver /data/adb/modules/$MODID/module.prop 2>/dev/null || :)
currVer=$(wget https://raw.githubusercontent.com/johnfawkes/$MODID/master/module.prop --output-document - | get_ver)
zip=https://gitreleases.dev/gh/johnfawkes/fontchanger/latest/Fontchanger-$currVer.zip
if [ $currVer -gt $instVer ]; then 
  wget --no-check-certificate -q -O $FCDIR/updates/Fontchanger-$currVer.zip $zip
  mkdir -p Fontchanger-$currVer
  unzip -o "Fontchanger-$currVer.zip" -d $FCDIR/updates/Fontchanger-$currVer >&2
  cd Fontchanger-$currVer
  sh install-current.sh
  wait
else
  echo "[!] No Update Available [!]"
fi
if [ -d $FCDIR/updates/FontChanger-$currVer ]; then
  rm -rf $FCDIR/updates/Fontchanger-$currVer
fi
}

cd $FCDIR
[ ! -d $FCDIR/updates ] || mkdir updates
cd $FCDIR/updates
updater