#/usr/bin/env bash
set -x
# mount fix
grep -v rootfs /proc/mounts > /etc/mtab

/usr/bin/supervisord
