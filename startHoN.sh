#!/bin/sh

WILLOWMAKER_VERSION="2.1.3"

mkdir -p ~/.Heroes\ of\ Newerth/game

REMOVE_MODESETTING=false
if [ ! -f ~/.Heroes\ of\ Newerth/game/startup.cfg ]; then
  REMOVE_MODESETTING=true
else
  grep -Fxq 'SetSave "gl_modesetting" ""' ~/.Heroes\ of\ Newerth/game/startup.cfg
  if [ $? -eq 1 ]; then
    REMOVE_MODESETTING=true
  fi
fi

if [ $REMOVE_MODESETTING ]; then
  echo "Appending gl_modesetting configuration to startup.cfg"
  echo 'SetSave "gl_modesetting" ""' >>~/.Heroes\ of\ Newerth/game/startup.cfg
fi

cd "$XDG_DATA_HOME" || exit 1

if [ ! -f "$XDG_DATA_HOME/WILLOWMAKER" ]; then
  wget "https://github.com/Project-KONGOR-Open-Source/WILLOWMAKER/releases/download/v2.1.3/linux-x64-v${WILLOWMAKER_VERSION}.zip" || exit 1
  unzip "linux-x64-v${WILLOWMAKER_VERSION}.zip" || exit 1
  rm "linux-x64-v${WILLOWMAKER_VERSION}.zip"
fi

exec "$XDG_DATA_HOME/WILLOWMAKER" "$*"
