#!/usr/bin/env bash
container="*"
[[ $# -eq 1 ]] && container=$1

name=$(basename $0)
shopt -u extglob
docker stop $(docker ps -a | grep -v CONTAINER | grep -E "$container" | cut -f1 -d ' ')
if [[ $name == "remove-docker-containers" ]]; then
    docker rm $(docker ps -a | grep -v CONTAINER | grep -E "$container" | cut -f1 -d ' ')
fi
