#!/bin/sh
set -e

rmmod evbug || true

userns_procfs_path=/proc/sys/user/max_user_namespaces
desired_max_userns=256681
while sleep 0.1; do
	old_val=$(cat "$userns_procfs_path")
	if [ "$old_val" -lt "$desired_max_userns" ]; then
		echo "$desired_max_userns" > "$userns_procfs_path"
		printf "Changed max_user_namespaces, %d -> %d\n" \
			"$old_val" "$(cat "$userns_procfs_path")"
	fi
done
