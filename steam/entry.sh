#!/bin/bash
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

setup_binfmt_handlers() {
	BINFMT_MISC_FS=/proc/sys/fs/binfmt_misc
	if [ -f /etc/binfmt.d/box86.conf ]; then
		if ! mountpoint $BINFMT_MISC_FS; then
			mount -t binfmt_misc none $BINFMT_MISC_FS
		else
			echo "binfmt_misc already mounted"
		fi

		if [ ! -f $BINFMT_MISC_FS/x86 ]; then
			grep -v '^#' /etc/binfmt.d/box86.conf > $BINFMT_MISC_FS/register
		else
			echo "x86 handler already registered"
		fi
	fi
}

setup_devtmpfs
setup_binfmt_handlers

while ! xset -q; do
	sleep 1;
done

su steamuser -c 'STEAMOS=1 STEAM_RUNTIME=1 /usr/bin/steam -tcp +open steam://open/minigameslist'
