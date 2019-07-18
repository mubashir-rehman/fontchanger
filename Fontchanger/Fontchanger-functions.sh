invaild() {
echo -e "${R}Invaild Option...${N}"; clear
}

return_menu() {
  echo -n "${R}Return to menu? < y | n > : ${N}"
  read -r mchoice
  case $mchoice in
    y|Y) menu;;
    n|N) clear; quit;;
    *) invaild;;
  esac
}

emoji_reboot_menu() {
  echo -e "${B}Emoji Applied Successfully...${N}"
  echo -e "${R}You Will Need to Reboot to Apply Changes${N}"
  echo -n "${R}Reboot? < y | n > : ${N}"
  read -r mchoice
  case $mchoice in
    y|Y) reboot;;
    n|N) return_menu;;
    *) invaild;;
  esac 
}

font_reboot_menu() {
  echo -e "${B}Font Applied Successfully...${N}"
  echo -e "${R}You Will Need to Reboot to Apply Changes${N}"
  echo -n "${R}Reboot? < y | n > : ${N}"
  read -r mchoice
  case $mchoice in
    y|Y) reboot;;
    n|N) return_menu;;
    *) invaild;;
  esac 
}

retry() {
  echo -e "${R}[!] FONT WAS NOT APPLIED [!]${N}"
  echo -e "${R} PLEASE TRY AGAIN${N}"
  sleep 3
  clear
}

#######################################################################################################
#                                               LOGGING                                               #
#######################################################################################################
# Loggers
LOGGERS="
$CACHELOC/magisk.log
$CACHELOC/magisk.log.bak
$MODPATH/system/bin/font_changer
/data/adb/magisk_debug.log
$MODPATH/$MODID.log
$MODPATH/$MODID-old.log
$MODPATH/$MODID-verbose.log
$MODPATH/$MODID-verbose-old.log
$FCDIR
"

log_handler() {
	if [ $(id -u) == 0 ] ; then
		echo "" >> $LOG 2>&1
		echo -e "$(date +"%m-%d-%Y %H:%M:%S") - $1" >> $LOG 2>&1
	fi
}

log_print() {
	echo "$1"
	log_handler "$1"
}

log_script_chk() {
	log_handler "$1"
	echo -e "$(date +"%m-%d-%Y %H:%M:%S") - $1" >> $LOG 2>&1
}

#Log Functions
# Saves the previous log (if available) and creates a new one
log_start() {
if [ -f "$LOG" ]; then
	mv -f $LOG $oldLOG
fi
touch $LOG
echo " " >> $LOG 2>&1
echo "    *********************************************" >> $LOG 2>&1
echo "    *              FontChanger                  *" >> $LOG 2>&1
echo "    *********************************************" >> $LOG 2>&1
echo "    *                 $VER                      *" >> $LOG 2>&1
echo "    *              John Fawkes                  *" >> $LOG 2>&1
echo "    *********************************************" >> $LOG 2>&1
echo " " >> $LOG 2>&1
log_script_chk "Log start."
}

# PRINT MOD NAME
log_start

collect_logs() {
	log_handler "Collecting logs and information."
	# Create temporary directory
	mkdir -pv $TMPLOGLOC >> $LOG 2>&1

	# Saving Magisk and module log files and device original build.prop
	for ITEM in $LOGGERS; do
		if [ -f "$ITEM" ]; then
			case "$ITEM" in
				*build.prop*)	BPNAME="build_$(echo $ITEM | sed 's|\/build.prop||' | sed 's|.*\/||g').prop"
				;;
				*)	BPNAME=""
				;;
			esac
			cp -af $ITEM ${TMPLOGLOC}/${BPNAME} >> $LOG 2>&1
	  else
			case "$ITEM" in
				*/cache)
				  if [ "$CACHELOC" == "/cache" ]; then
						CACHELOCTMP=/cache
					else
						CACHELOCTMP=/data/cache
					fi
					  ITEMTPM=$(echo $ITEM | sed 's|$CACecho -n "${R}Return to menu? < y | n > : ${N}"CACHELOCTMP|')
					if [ -f "$ITEMTPM" ]; then
						cp -af $ITEMTPM $TMPLOGLOC >> $LOG  read -r mchoice
					else
						log_handler "$ITEM not available."  [ "$mchoice" == "y" ] && menu || clear && quit
					fi ;;
				*)	log_handler "$ITEM not available." ;;
			esac
    fi
	done
# Saving the current prop values
if $MAGISK; then
  log_handler "RESETPROPS"
  echo "==========================================" >> $LOG 2>&1
	resetprop >> $LOG 2>&1
else
  log_handler "GETPROPS"
  echo "==========================================" >> $LOG 2>&1
	getprop >> $LOG 2>&1
fi
if $MAGISK; then
  log_print " Collecting Modules Installed "
  echo "==========================================" >> $LOG 2>&1
  ls $MODPATH >> $LOG 2>&1
  log_print " Collecting Logs for Installed Files "
  echo "==========================================" >> $LOG 2>&1
  log_handler "$(du -ah $MODPATH)" >> $LOG 2>&1
  echo "==========================================" >> $LOG 2>&1
fi

# Package the files
cd $CACHELOC
tar -zcvf FontChanger_logs.tar.xz FontChanger_logs >> $LOG 2>&1

# Copy package to internal storage
mv -f $CACHELOC/FontChanger_logs.tar.xz $FCDIR >> $LOG 2>&1

if  [ -e $FCDIR/FontChanger_logs.tar.xz ]; then
  log_print "FontChanger_logs.tar.xz Created Successfully."
else
  log_print "Archive File Not Created. Error in Script. Please contact John Fawkes on Github or Telegram"
fi

# Remove temporary directory
rm -rf $TMPLOGLOC >> $LOG 2>&1

log_handler "Logs and information collected."
}

# Load functions
log_start "Running Log script." >> $LOG 2>&1

#######################################################################################################
#                                               HELP                                                  #
#######################################################################################################
help() {
  cat << EOF
$MODTITLE $VER($REL)
by $AUTHOR
Copyright (C) 2019, John Fawkes @ xda-developers
License: GPLv3+

Usage: $_name
   or: $_name [options]...
   
Options:
  -a|--font [font name]         apply the font
    e.g., font_changer -a Font_UbuntuLight
    e.g., font_changer --font Font_UbuntuLight
  
  -d|--cfont [custom font]      apply the custom font
  e.g., font_changer -d <name of custom font>
  e.g., font_changer --cfont <name of custom font>
  
  -h|--help                     show this message
  e.g., font_changer -h
  e.g., font_changer --help

  -l|--listc                    list custom fonts
  e.g., font_changer -l
  e.g., font_changer --listc

  -m|--list                     list fonts <basically skips main menu>
  e.g., font_changer -m
  e.g., font_changer --list
  
  -s|--current                  show current font
  e.g., font_changer -s
  e.g., font_changer --current
  
  

  echo "${G}Welcome to the How-to for FontChanger!${N}"
  echo "${G}This is the Folder Structure You Will Need to Follow${N}"
  echo "${G}In Order for FontChanger to Properly Detect and Apply Your Font!${N}"
  echo "${G}Note ------ /sdcard Equals Internal Storage  ${N}"
  echo " "
  echo " "
  echo " "
  echo "     |--Fontchanger/"
  echo "          |--Fonts/"
  echo "              |--Custom/"
  echo -e "              ${R}|--<font-folder-name>/${N}"
  echo -e "                       ${G}|--<font>.ttf${N}"
  echo -e "                       ${G}|--<font>.ttf${N}"
  echo " "
  echo " You Need To Place Your Font Folders in /storage/emulated/0/Fontchanger/Fonts/Custom."
  echo " The Folder in ${R}RED${N} is Name of the Font You Want to Apply."
  echo " This Would be the Main Folder That Holds the ttf Files for That Font."
  echo " The Files in ${G}GREEN${N} are the ttf Files For That Specific Font."
  echo " You Can Have Multiple Font Folders Inside the Fontchanger/Fonts Folder."
  echo " After Creating and Placing the Correct Folders and ttf Files in the Fonts Folder"
  echo " Make Sure to Name the Font Folder the Same Name as The ttf files."
  echo " So if the ttf files are Called cooljazz*.ttf Then You'll Need to Name"
  echo " the Folder Inside Custom, cooljazz in Order for the Font to Apply Correctly."
  echo " Please Go Back to Apply the Font of Your Choice"
EOF
  return_menu
exit
}

#######################################################################################################
#                                         EMOJIS                                                      #
#######################################################################################################
apply_emoji() {
echo -e "${B}Applying Emoji. Please Wait...${N}"
sleep 2
choice2="$(grep -w $choice $MODPATH/emojilist.txt | tr -d '[ ]' | tr -d $choice | tr -d ' ')"
rm -f $MODPATH/system/fonts/*Emoji > /dev/null 2>&1
if [ ! -d $MODPATH/system/fonts ]; then
  mkdir -p $MODPATH/system/fonts > /dev/null 2>&1
fi
if [ ! -f /system/etc/fonts.xml ]; then
  mkdir -p $MODPATH/system/etc > /dev/null 2>&1
  curl -k -o "$FCDIR/Fonts/fonts.xml" https://john-fawkes.com/Downloads/xml/fonts.xml
  cp -f $FCDIR/Fonts/fonts.xml $MODPATH/system/etc
  set_perm $MODPATH/system/etc/fonts.xml 0 0 0644
fi
curl -k -o "$FCDIR/Fonts/$choice2.zip" https://john-fawkes.com/Downloads/emoji/$choice2.zip
unzip -o "$FCDIR/Fonts/$choice2.zip" 'system/*' -d $MODPATH >&2
if [ -e $MIRROR/system/fonts/SamsungColorEmoji.ttf ]; then
  cp -f $MODPATH/system/fonts/$choice2.ttf $MODPATH/system/fonts/SamsungColorEmoji.ttf
fi
if [ -e $MIRROR/system/fonts/hTC_ColorEmoji.ttf ]; then
  cp -f $MODPATH/system/fonts/$choice2.ttf $MODPATH/system/fonts/hTC_ColorEmoji.ttf
fi
set_perm_recursive $MODPATH/system/fonts 0 0 0755 0644 > /dev/null 2>&1
truncate -s 0 $CFONT
echo -n "CURRENT=$choice2" >> $CFONT
if [ -d "$FCDIR/Fonts/$choice2.zip" ] && [ -d $MODPATH/system/fonts ]; then
  font_reboot_menu
else
  echo -e "${R}[!] Emoji WAS NOT APPLIED [!]${N}"
  echo -e "${R} PLEASE TRY AGAIN${N}"
  sleep 3
  clear
fi
}

list_emoji() {
num=1
rm $MODPATH/emojilist.txt > /dev/null 2>&1
emojis=($(cat $FCDIR/emojis-list.txt | sed 's/.zip//'))
touch $MODPATH/emojilist.txt > /dev/null 2>&1
for i in ${emojis[@]}; do
  ProgressBar $num ${#emojis[@]}
  num=$((num+1))
done
}

emoji_menu() {
clear
list_emoji
clear
echo "$div"
title_div "Emojis"
echo "$div"
echo ""
num=1
for emoji in ${emojis[@]}; do
  echo -e "${W}[$num]${N} ${G}$emoji${N}" && echo " [$num] $emoji" >> $MODPATH/emojilist.txt
  num=$((num+1))
done
echo ""
wrong=$(cat $MODPATH/emojilist.txt | wc -l)
echo -e "${G}Please Choose an emoji to Apply. Enter the Corresponding Number...${N}"
read -r choice
case $choice in
  $choice)
    if [ $choice == "q" ]; then
      echo "${R}Quiting...${N}"
      clear
      quit
    elif [ $choice -gt $wrong ]; then
      echo "${Y}[!] Item Not Available! Try Again... [!]${N}"
      sleep 1.5
      clear
    else
      apply_emoji
    fi
    ;;
  esac
}
#######################################################################################################
#                                         CUSTOM FONTS                                                #
#######################################################################################################
apply_custom_font() {
choice2="$(grep -w $choice $MODPATH/customfontlist.txt | tr -d '[ ]' | tr -d $choice | tr -d ' ')"
choice3=(
$(find $FCDIR/Fonts/Custom/$choice2 -maxdepth 1 -type f -name "*.ttf" -o -name "*.ttc" -prune | sed 's#.*/##'| sort -r)
)
choice4=$(ls $MIRROR/system/fonts | wc -l)
if [ -f $MODPATH/system/fonts/*Emoji*.ttf ]; then
  for i in $MODPATH/system/fonts/*Emoji*.ttf; do
    mv -f $i $MODPATH
  done
fi
rm -rf $MODPATH/system/fonts > /dev/null 2>&1
mkdir -p $MODPATH/system/fonts > /dev/null 2>&1
touch $MODPATH/system/etc/fonts.xml
XML=$MODPATH/system/etc/fonts.xml
if [ -f $XML ]; then
  rm -rf $XML
  touch $XML
else
  touch $XML
fi
#sed -i "s|<family name=".*"|<family name=\"$choice2\">|1" $XML
truncate -s 0 $XML
  echo "<?xml version=\"1.0\" encoding=\"utf-8\"?>
<!--
	Generated by $MODTITLE by $AUTHOR
-->
<familyset version=\"22\">
    <family name=\"sans-serif\">" >> $XML
for i in ${choice3[@]}; do
  echo "        <font weight=\"400\" style=\"normal\">\"$i\"</font>" >> $XML
done
echo "    </family>
    <alias name=\"sans-serif-thin\" to=\"sans-serif\" weight=\"100\" />
    <alias name=\"sans-serif-light\" to=\"sans-serif\" weight=\"300\" />
    <alias name=\"sans-serif-medium\" to=\"sans-serif\" weight=\"500\" />
    <alias name=\"sans-serif-black\" to=\"sans-serif\" weight=\"900\" />
    <alias name=\"arial\" to=\"sans-serif\" />
    <alias name=\"helvetica\" to=\"sans-serif\" />
    <alias name=\"tahoma\" to=\"sans-serif\" />
    <alias name=\"verdana\" to=\"sans-serif\" />
    <alias name=\"sans-serif-condensed\" to=\"sans-serif\" />
</familyset>" >> $XML
if [ -f $MODPATH/*Emoji*.ttf ]; then
  for i in $MODPATH/*Emoji*.ttf; do
    mv -f $i $MODPATH/system/fonts
  done
fi
cp -f $FCDIR/Fonts/Custom/$choice2/* $MODPATH/system/fonts/
}

list_custom_fonts() {
num=1
rm $MODPATH/customfontlist.txt > /dev/null 2>&1
touch $MODPATH/customfontlist.txt > /dev/null 2>&1
for i in $(ls "$FCDIR/Fonts/Custom" | sort); do
  sleep 0.1
  echo -e "[$num] $i" >> $MODPATH/customfontlist.txt && echo "${W}[$num]${N} ${B}$i${N}"
  num=$((num+1))
done
}

custom_menu() {
list_custom_fonts
wrong=$(cat $MODPATH/customfontlist.txt | wc -l) 
echo -e "${G}Please Choose a Font to Apply. Enter the Corresponding Number...${N}"
read -r choice
case $choice in
  $choice)
    if [ $choice == "q" ]; then
      echo "${R}Quiting...${N}"
      clear
      quit
    elif [  $choice -gt $wrong ]; then
      echo "${Y}[!] Item Not Available! Try Again... [!]${N}"
      sleep 1.5
      clear
    else
      apply_custom_font
    fi
    ;;
esac
}
#######################################################################################################
#                                         DOWNLOADABLE FONTS                                          #
#######################################################################################################
apply_font() {
nofont=$(find $MIRROR/system/fonts -maxdepth 1 -type f -name "*ockScreen*.ttf" -o -name "*otoSerif*.ttf" -o -name "*roidsans*.ttf" -o -name "*ancing*.ttf" -o -name "*ndroidClock*.ttf" -o -name "*ont*.ttf" -o -name "*omingSoon*.ttf" -o -name "*utiveMono*.ttf" -o -name "*arroisGothic*.ttf"  | sed 's#.*/##' | sort -r)
choice4=$(ls $MIRROR/system/fonts | wc -l)
echo -e "${B}Applying Font. Please Wait...${N}"
sleep 2
choice2="$(grep -w $choice $MODPATH/fontlist.txt | tr -d '[ ]' | tr -d $choice | tr -d ' ')"
choice3=(
$(find $FCDIR/Fonts/$choice2/system/fonts -maxdepth 1 -type f -name "*.ttf" -o -name "*.ttc" -prune | sed 's#.*/##'| sort -r)
)
if [ -f $MODPATH/system/fonts/*Emoji*.ttf ]; then
  for i in $MODPATH/system/fonts/*Emoji*.ttf; do
    mv -f $i $MODPATH
  done
fi
rm -rf $MODPATH/system/fonts > /dev/null 2>&1
mkdir -p $MODPATH/system/fonts > /dev/null 2>&1
#if [ ! -f /system/etc/fonts.xml ]; then
#  mkdir -p $MODPATH/system/etc > /dev/null 2>&1
#  curl -k -o "$FCDIR/Fonts/fonts.xml" https://john-fawkes.com/Downloads/xml/fonts.xml
#  cp -f $FCDIR/Fonts/fonts.xml $MODPATH/system/etc
#  set_perm $MODPATH/system/etc/fonts.xml 0 0 0644
#fi
curl -k -o "$FCDIR/Fonts/$choice2.zip" https://john-fawkes.com/Downloads/$choice2.zip
mkdir -p $FCDIR/Fonts/$choice2
unzip -o "$FCDIR/Fonts/$choice2.zip" 'system/*' -d $FCDIR/Fonts/$choice2 >&2 
mkdir -p $MODPATH/system/fonts
cp -rf $FCDIR/Fonts/$choice2/system/fonts/ $MODPATH/system/fonts
XML=$MODPATH/system/etc/fonts.xml
if [ -f $XML ]; then
  rm -rf $XML
  touch $XML
else
  touch $XML
fi
#sed -i "s|<family name=".*"|<family name=\"$choice2\">|1" $XML
truncate -s 0 $XML
  echo "<?xml version=\"1.0\" encoding=\"utf-8\"?>
<!--
	Generated by $MODTITLE by $AUTHOR
-->
<familyset version=\"22\">
    <family name=\"sans-serif\">" >> $XML
for i in ${choice3[@]}; do
  echo "        <font weight=\"400\" style=\"normal\">\"$i\"</font>" >> $XML
done
echo "    </family>
    <alias name=\"sans-serif-thin\" to=\"sans-serif\" weight=\"100\" />
    <alias name=\"sans-serif-light\" to=\"sans-serif\" weight=\"300\" />
    <alias name=\"sans-serif-medium\" to=\"sans-serif\" weight=\"500\" />
    <alias name=\"sans-serif-black\" to=\"sans-serif\" weight=\"900\" />
    <alias name=\"arial\" to=\"sans-serif\" />
    <alias name=\"helvetica\" to=\"sans-serif\" />
    <alias name=\"tahoma\" to=\"sans-serif\" />
    <alias name=\"verdana\" to=\"sans-serif\" />
    <alias name=\"sans-serif-condensed\" to=\"sans-serif\" />
</familyset>" >> $XML

if [ -f $MODPATH/*Emoji*.ttf ]; then
  for i in $MODPATH/*Emoji*.ttf; do
    mv -f $i $MODPATH/system/fonts
  done
fi
set_perm_recursive $MODPATH/system/fonts 0 0 0755 0644 > /dev/null 2>&1
truncate -s 0 $CFONT
echo -n "CURRENT=$choice2" >> $CFONT
if [ -f "$FCDIR/Fonts/$choice2.zip" ] && [ -d $MODPATH/system/fonts ]; then
  font_reboot_menu
else
  retry
fi
}

list_fonts() {
num=1
rm $MODPATH/fontlist.txt > /dev/null 2>&1
fonts=($(cat $FCDIR/fonts-list.txt | sed 's/.zip//'))
touch $MODPATH/fontlist.txt > /dev/null 2>&1
for i in ${fonts[@]}; do
  ProgressBar $num ${#fonts[@]}
  num=$((num+1))
done
}

font_menu() {
clear
list_fonts
clear
echo "$div"
title_div "Fonts"
echo "$div"
echo ""
num=1
for font in ${fonts[@]}; do
  echo -e "${W}[$num]${N} ${G}$font${N}" && echo " [$num] $font" >> $MODPATH/fontlist.txt
  num=$((num+1))
done
echo ""
wrong=$(cat $MODPATH/fontlist.txt | wc -l)
echo -e "${G}Please Choose a Font to Apply. Enter the Corresponding Number...${N}"
read -r choice
case $choice in
  $choice)
    if [ $choice == "q" ]; then
      echo "${R}Quiting...${N}"
      clear
      quit
    elif [ $choice -gt $wrong ]; then
      echo "${Y}[!] Item Not Available! Try Again... [!]${N}"
      sleep 1.5
      clear
    else
      apply_font
    fi
    ;;
  esac
}

default_menu() {
echo -e "${G}Would You Like to Restore your Default Font?${N}"
echo -e "${G}Please Enter (y)es or (n)o...${N}"
read -r choice
case $choice in
  y|yes) echo -e "${B}Restore Default Selected...${N}"
    if [ -f $MODPATH/system/fonts/*Emoji*.ttf ]; then
      echo -e "${B}Would You like to Keep Your Emojis?${N}"
      echo -e "${B}Please Enter (y)es or (n)o...${N}"
      read -r emojichoice
        case $emojichoice in
          y|yes) echo -e "${Y}Backing up Emojis${N}"
            for i in $MODPATH/*Emoji*.ttf; do
              mv -f $i $MODPATH/system/fonts
            done
            break;;
          n|no) echo -e "${R}Removing Emojis${N}"
            break;;
        esac
    fi
    rm -rf $MODPATH/system/fonts
    rm -f $MODPATH/system/etc/fonts.xml
    truncate -s 0 $CFONT
    break
    ;;
  n|no) echo -e "${C}Keeping Modded Font...${N}"
    break
    ;;
  *) invaild
    sleep 1.5
    clear
    ;;
esac
return_menu
}
