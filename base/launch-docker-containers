#!/usr/bin/env bash
[[ $# -lt 2 ]] && echo "$(basename $0) <container> <tag> [# of containers]" && exit 1
container=$1
tag=$2

image="$USER/$container:$tag"
container_datadir=/opt/data
host_datadir=/opt/data/$container
cnt=3
[[ $# -eq 3 ]] && cnt=$3

for ((i=1; i<=cnt; i++)); do
    [[ ! -d $host_datadir-$i ]] && sudo mkdir -p $host_datadir-$i
    docker run -t -i -d -h $container-$i --name="$container-$i" -v $host_datadir-$i:$container_datadir $image
done
