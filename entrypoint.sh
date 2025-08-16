#!/bin/bash
sudo service dbus start
sudo service dbus status
VNC_PASSWORD=${VNC_PASSWORD:-123456}
mkdir -p .config/tigervnc
echo $VNC_PASSWORD | vncpasswd -f > .config/tigervnc/passwd
chmod 600 .config/tigervnc/passwd
tigervncserver
./noVNC/utils/novnc_proxy --vnc localhost:5901
