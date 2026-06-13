#!/bin/sh

SELF_DIR="$(dirname "$(readlink -f "$0")")"

mkdir -p $XDG_DATA_HOME/libs-x86_64/
ln -sf "/lib/x86_64-linux-gnu/libudev.so.1" "$XDG_DATA_HOME/libs-x86_64/libudev.so.0"

if [ ! -f "$XDG_DATA_HOME/game/resources0.s2z" ]
then
  echo "Please manually install HoN and copy/move the installed files to $XDG_DATA_HOME/game"
  echo "The hon.sh file should be located right under that directory."
  exit 1

  echo "This will output a couple of errors from unzip - please ignore them."
  DOWNLOAD_DIR="$XDG_DATA_HOME"
  mkdir -p "$DOWNLOAD_DIR/hon-downloader"
  cd "$DOWNLOAD_DIR/hon-downloader"
  wget -q -O manifest.xml.zip http://dl.heroesofnewerth.com/lac/x86-biarch/4.8.4/manifest.xml.zip
  unzip -q -o manifest.xml.zip

  for path in "" game/ libs-x86_64/ base/ updater_resources/
  do
    mkdir -p "${DOWNLOAD_DIR}/${path}"
    cd "${DOWNLOAD_DIR}/${path}"
    for url in `grep -i "<file path=\"$path[^/]*\"" "$DOWNLOAD_DIR/hon-downloader/manifest.xml" | sed 's~.*path="\([^"]*\)".*version="\([^"]*\)\.[0-9]".*~http://dl.heroesofnewerth.com/lac/x86-biarch/\2/\1.zip~'`
    do
      wget -q -O output.zip $url
      unzip -q -o output.zip
      if [ $? -ne 0 ];
      then echo $url
      fi
      rm output.zip
    done
    cd "$SELF_DIR"
  done

  chmod +x "$XDG_DATA_HOME/hon-x86_64"

  rm -f "$XDG_DATA_HOME/libs-x86_64/libstdc++.so.6" "$XDG_DATA_HOME/libs-x86_64/libfreetype.so.6"

  exec "$XDG_DATA_HOME/hon-x86_64" "-repair"
fi

rm -f "$XDG_DATA_HOME/libs-x86_64/libstdc++.so.6" "$XDG_DATA_HOME/libs-x86_64/libfreetype.so.6"

mkdir -p ~/.Heroes\ of\ Newerth/game

REMOVE_MODESETTING=false
if [ ! -f ~/.Heroes\ of\ Newerth/game/startup.cfg ]
then
  REMOVE_MODESETTING=true
else
  grep -Fxq 'SetSave "gl_modesetting" ""' ~/.Heroes\ of\ Newerth/game/startup.cfg
  if [ $? -eq 1 ]
  then REMOVE_MODESETTING=true
  fi
fi

if [ $REMOVE_MODESETTING ]
then echo "Appending gl_modesetting configuration to startup.cfg"
echo 'SetSave "gl_modesetting" ""' >> ~/.Heroes\ of\ Newerth/game/startup.cfg
fi

exec "$XDG_DATA_HOME/launcher" "$*"
