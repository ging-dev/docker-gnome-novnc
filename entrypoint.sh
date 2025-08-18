#!/bin/bash

VNC_PASSWORD=${VNC_PASSWORD:-123456}
GEOMETRY=${GEOMETRY:-1024x768}

echo $VNC_PASSWORD | vncpasswd -f > .config/tigervnc/passwd

# Clear tigervnc log before restart
rm .config/tigervnc/*.log
sudo service dbus start
tigervncserver -geometry $GEOMETRY
./noVNC/utils/novnc_proxy --vnc localhost:5901
