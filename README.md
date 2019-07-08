<h1 align="center">Font Changer</h1>

<div align="center">
  <!-- Version -->
    <img src="https://img.shields.io/badge/Version-v1.9-blue.svg?longCache=true&style=popout-square"
      alt="Version" />
  <!-- Last Updated -->
    <img src="https://img.shields.io/badge/Updated-July 7, 2019-green.svg?longCache=true&style=flat-square"
      alt="_time_stamp_" />
</div>

<div align="center">
  <strong>Font Changer allows the user to download over 200 fonts and apply them. If the user doesn't like any of the fonts or the font the want isn't in the list, then they can put the ttf files in a custom folder in internal storage! After installing and rebooting, open a terminal emulator and type su hit enter then type font_changer and choose option 1 to download one of the fonts provided.
</div>

<div align="center">
  <h3>
    <a href="https://github.com/johnfawkes/fontchanger">
      Source Code
    </a>
  </h3>
</div>

## Support
- Please open an issue on my github page <a href="https://github.com/Magisk-Modules-Repo/fontchanger"> Github </a> or if your on Telegram please join <a href="https://t.me/fontchange_magisk"> Telegram </a> Telegram i will see and fix the issue faster as I am always on Telegram.

## Compatibility
- Magisk 18.0 +
- All devices
- All Android versions
- <s>Roboto font as default font (until further notice)</s>

## Credits
- Font Files from <a href="https://forum.xda-developers.com/android/themes/fonts-flashable-zips-t3219827">@giaton @xdadevelopers</a>
- For making Midnight Core <a href="https://forum.xda-developers.com/member.php?u=8918441">@oldmid @xdadevelopers</a>
- For making and allowing me to use his busybox <a href="https://forum.xda-developers.com/member.php?u=4544860">@osm0sis</a>
- For some code and the update feature <a href="https://t.me/vr25xda/">@vr25</a>

## Donators
- <a href="t.me/botom8">@botom8 Telegram</a>

## Changelog
### v1.9 - 7.07.2019
* revamped help menu. choose from main menu or use font_changer -h or font_changer -help
* new shortcuts options. 
Options:
    -a|—font [font name]        apply the font
    -d|—cfont [custom font]     apply the custom font
    -h|—help                    help
    -l|—listc                   list custom fonts
    -m|—list                    list fonts <basically skips main menu>
    -s|—current                 show current font
    -u|—update                  Update to latest beta
* New colors to make certain things stand out more such as your current font
* bug fixes for things like choosing y on reboot no longer shows back to main menu.
* fix custom fonts (hopefully)
* start emoji support
* Better logging support. now it will put everything i need to fix bugs into a tar.xz in the Fontchanger folder in internal storage. please send me this tar.xz if you encounter any bugs ( This feature will be finished in v2.0)
* added GNU sleep command compiled from source code. no more sleep invaild errors.
* added progress bar. now list loads faster. (will be applied to custom list in later update)
* Update feature. now you can use -u flag or —update to update to beta builds. no more searching telegram for the latest

### v1.8 - 6.18.2019
* Now fonts with only one file can be applied.
* add ttc support
* Bug fixes with custom
* Now all fonts are replaced 

### v1.7 - 6.14.2019
* Fix custom Fonts applying for devices that dont use Roboto as default font
* No longer requires Roboto as default font

### v1.6 - 6.14.2019
* Add new connection checker
* fix shebang for whatever reason

### v1.5 - 6.14.2019
* Add osm0sis busybox to use ping durning install

### v1.4 - 6.14.2019
* Add curl during install for users that dont have curl on their devices

### v1.3 - 6.14.2019
* Fix issue with curl choosing multiple fonts. Everything below 100 will work now. 
* Fix ttf typo in help
* Other bug fixes/typos

### v1.2 - 6.14.2019
* Fix typo with fonts. fonts will be found now. sorry about that

### v1.1 - 6.11.2019
* Fix Duplicate fonts being applied by removing old font files when applying a new font
* Fix custom fonts showing in a list correctly
* Rename custom font files to roboto since roboto is 99% of the time the default font

### v1 - 6.04.2019
* Initial Version