#!/usr/bin/dumb-init /bin/sh

VNC_PASSWORD=${VNC_PASSWORD:-123456}
GEOMETRY=${GEOMETRY:-1024x768}

echo $VNC_PASSWORD | vncpasswd -f > .config/tigervnc/passwd

sudo service dbus start
tigervncserver :1 -geometry $GEOMETRY -fg &
/usr/share/novnc/utils/novnc_proxy --vnc localhost:5901
