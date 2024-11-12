#!/bin/bash
# Create .vnc directory
mkdir -p /home/chrome/.vnc

# Set VNC password
x11vnc -storepasswd ${VNC_PASSWORD:-browsershell} /home/chrome/.vnc/passwd

# Start supervisord
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
