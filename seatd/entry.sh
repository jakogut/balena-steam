#!/bin/sh
set -e

setup_devtmpfs() {
	newdev=/tmp/dev
	mkdir -p "$newdev"
	mount -t devtmpfs none "$newdev"
	mount --move /dev/console "$newdev/console"
	mount --move /dev/mqueue "$newdev/mqueue"
	mount --move /dev/pts "$newdev/pts"
	mount --move /dev/shm "$newdev/shm"
	umount /dev
	mount --move "$newdev" /dev
	ln -sf /dev/pts/ptmx /dev/ptmx
}

stop_service() {
	dbus-send \
		--system \
		--dest=org.freedesktop.systemd1 \
		--print-reply \
		/org/freedesktop/systemd1 \
		org.freedesktop.systemd1.Manager.StopUnit \
		"string:$1" string:replace
}

# give access to VTs and input devices to seatd
setup_devtmpfs

# take DRM master away
stop_service plymouth-start.service

seatd -u user -g user
