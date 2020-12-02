#!/bin/sh

DEFAULT_REAPER_FOLDER="reaper_linux_x86_64"
DEFAULT_PATH="_linux_x86_64.tar.xz"

#sudo apt update
#sudo apt install appimage

curl "https://www.reaper.fm/download.php#linux_download" > download.php
LINK=$(cat download.php | grep -oP \".*$DEFAULT_PATH\")
LINK="https://www.reaper.fm/"$(echo $LINK | sed 's/[\"]//g')
FILENAME=${LINK##*/}
NAME=${FILENAME%"$DEFAULT_PATH"}
FOLDERNAME=$NAME".AppDir"

wget $LINK -O $FILENAME
tar xf $FILENAME

gsutil cp -r "gs://reaper-export/appimage-data" .
mv appimage-data $FOLDERNAME
cp -r $DEFAULT_REAPER_FOLDER/REAPER $FOLDERNAME

APPIMAGETOOL=appimagetool-x86_64.AppImage
wget "https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage"
chmod a+x $APPIMAGETOOL
chmod a+x $FOLDERNAME/AppRun
./appimagetool-x86_64.AppImage $FOLDERNAME

rm download.php
rm -r $FOLDERNAME
rm -r $DEFAULT_REAPER_FOLDER
rm $APPIMAGETOOL
rm $FILENAME

mv *.AppImage $NAME".AppImage"

gsutil mv $NAME".AppImage" "gs://reaper-export/appimage"
