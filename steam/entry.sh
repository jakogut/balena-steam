#!/bin/bash
set -e

mkdir -p /var/run/nscd
nscd

while [ "$(cat /proc/sys/user/max_user_namespaces)" -lt 100 ]; do sleep 0.1; done

printf "%s" "Waiting for pulseaudio..."
su steamuser -c "while ! pactl info; do sleep 0.1; done"
printf "%s\n" "done"

su steamuser -c "pactl set-sink-mute 0 0"
su steamuser -c "pactl set-sink-volume 0 100%"

printf "%s" "Waiting for display server..."
while ! su steamuser -c "xset -q >/dev/null"; do sleep 0.5; done
printf "%s\n" "done"

su steamuser -c 'STEAMOS=1 STEAM_RUNTIME=1 /usr/bin/steam -gamepadui'

