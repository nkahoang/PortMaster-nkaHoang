#!/bin/bash
# PORTMASTER: apricots.zip, Apricots.sh

if [ -d "/opt/system/Tools/PortMaster/" ]; then
  controlfolder="/opt/system/Tools/PortMaster"
elif [ -d "/opt/tools/PortMaster/" ]; then
  controlfolder="/opt/tools/PortMaster"
else
  controlfolder="/roms/ports/PortMaster"
fi

source $controlfolder/control.txt

get_controls


PORTDIR="/$directory/ports"
GAMEDIR="$PORTDIR/apricots"

export SDL_GAMECONTROLLERCONFIG="$sdl_controllerconfig"
export LD_LIBRARY_PATH="$GAMEDIR/libs"

cd $GAMEDIR

exec > >(tee "$GAMEDIR/log.txt") 2>&1

$ESUDO chmod 666 /dev/uinput
$ESUDO chmod 666 /dev/tty0

$GPTOKEYB "apricots" -c apricots.gptk &
./apricots

$ESUDO kill -9 $(pidof gptokeyb)
$ESUDO systemctl restart oga_events &
printf "\033c" > /dev/tty0