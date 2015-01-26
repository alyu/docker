#!/usr/bin/env bash

name="galera"
user=root
pass=root123
port=4567
mycnf=/etc/mysql/my.cnf

exec_cmd() {
    cnt=0
    rc=1
    until [[ $cnt -eq 6 ]] || [[ $rc -eq 0 ]]
    do
        echo "Running [$cnt]: $@"
        "$@"
        rc=$?
        cnt=$(($cnt + 1))
        sleep 3
    done

    if [[ $rc -ne 0 ]]
    then
        echo "Failed: $@"
        return $rc
    fi
}

hosts=()
address=""
cnt="$(docker ps | grep $name | wc -l)"
[[ $cnt -eq 0 ]] && echo "No galera containers running" && exit 1
for ((i=1; i<=cnt; i++)); do
    container_id=$(docker ps | grep "$name-$i" | awk '{print $1}')
    ip=$(docker inspect --format '{{ .NetworkSettings.IPAddress  }}' $container_id)
    hosts+=($ip)
done

for ((i=cnt-1; i>=0; i--)); do
    address="${hosts[i]}:$port,$address"
done
address="wsrep_cluster_address = gcomm://$address"
address=${address%?}
echo "** $address"
echo ""

for h in "${hosts[@]}"; do
    echo "ssh $user@$h \"sed -i \"s|.*wsrep_cluster_address.*=.*|$address|g\" $mycnf\""
    ssh $user@$h "sed -i \"s|.*wsrep_cluster_address.*=.*|$address|g\" $mycnf"
done

init_node=${hosts[0]}
unset hosts[0]

for h in "${hosts[@]}"; do
    exec_cmd ssh $user@$h "rm -f /var/lib/mysql/grastate.dat && service mysql restart"
    echo "***"
done
