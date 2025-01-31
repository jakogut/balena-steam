#!/bin/sh
cleanup () {
	rm -rf "${XDG_RUNTIME_DIR}" /tmp/.X11-unix/* /tmp/.X?-lock
}

cleanup

mkdir -p "${XDG_RUNTIME_DIR}"
chown -R user "${XDG_RUNTIME_DIR}"
chmod 700 "${XDG_RUNTIME_DIR}"

trap cleanup EXIT

# ensure the X socket is owned by the same user executing steam
su user -c "weston --xwayland --idle-time=0"
