#/usr/bin/env bash
set -x
# mount fix
grep -v rootfs /proc/mounts > /etc/mtab

# generate ssh keys
if [[ ! -f /etc/ssh/ssh_host_rsa_key  ]]; then
    ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa
    ssh-keygen -f /etc/ssh/ssh_host_dsa_key -N '' -t dsa
fi

/usr/bin/supervisord -c /etc/supervisord.conf
