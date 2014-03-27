#/usr/bin/env bash
set -x
# mount fix
grep -v rootfs /proc/mounts > /etc/mtab

# generate ssh keys
[[ ! -f /etc/ssh/ssh_host_rsa_key  ]] && service sshd start && service sshd stop

/usr/bin/supervisord
