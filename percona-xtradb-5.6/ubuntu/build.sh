#!/usr/bin/env bash
if [[ ! -f id_rsa.pub ]]; then
    echo "No public ssh key found. Generating a new ssh key"
    echo ""
    ssh-keygen -t rsa -N "" -f id_rsa
fi
docker build --rm=true -t $USER/ubuntu:pxc56 .

