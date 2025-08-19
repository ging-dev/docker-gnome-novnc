#!/bin/bash

shutdown() {
    sudo service dbus stop
    tigervncserver -kill :1
    exit 0
}

trap shutdown SIGTERM SIGINT SIGQUIT

VNC_PASSWORD=${VNC_PASSWORD:-123456}
GEOMETRY=${GEOMETRY:-1024x768}

echo $VNC_PASSWORD | vncpasswd -f > .config/tigervnc/passwd

sudo service dbus start
tigervncserver -geometry $GEOMETRY
/usr/share/novnc/utils/novnc_proxy --vnc localhost:5901 > /dev/null 2>&1 &
wait $!
