#!/usr/bin/env bash

image="$USER/centos:pxc56"
container="galera"
container_datadir=/var/lib/mysql
host_datadir=/mnt/data/centos-pxc56/mysql
cnt=3
[[ $# -eq 1 ]] && cnt=$1

for ((i=1; i<=cnt; i++)); do
    [[ ! -d $host_datadir-$i ]] && sudo mkdir -p $host_datadir-$i
    docker run -d --name="$container-$i" -v $host_datadir-$i:$container_datadir $image
done
