#!/bin/sh
rm -rf "${XDG_RUNTIME_DIR}/pulse"

udevd --daemon
udevadm trigger

chown root:snd /dev/snd/*

su user -c "
	pulseaudio \
		--system=no \
		--log-level=info \
		--log-target=stderr \
		--disallow-exit=yes \
		--exit-idle-time=-1 \
		--disable-shm \
		--daemonize=no \
		--load='module-native-protocol-unix auth-anonymous=1' \
		--load='module-udev-detect' \
	"
