# Docker files
Various docker files for dev/test.

## Percona XtraDB 5.6
This docker file creates an image with the most recent Percona XtraDB Cluster 5.6 package installed.
Each launched image starts a single bootstrapped Galera node. A launched image will check
if the MySQL server's data dir needs to be initated or can be re-used.

Run the bootstrap-cluster.sh script to bootstrap a cluster.
The script sets a proper wsrep-cluster-address for all instances named 'galera-N'
and then performs a rolling node restart of the DB nodes to join the cluster.

### Build a docker image
The default root user and MySQL server root password is 'root123'.
Ports exposed: 22 80 443 4444 4567 4568

Before creating the image, tune the my.cnf file to your liking.

#### centos:latest

    $ cd percona-xtradb-5.6/centos
    $ ./build.sh

#### ubuntu:latest

    $ cd percona-xtradb-5.6/ubuntu
    $ ./build.sh

    $ docker images

    alyu/ubuntu         pxc56               d440fdc4dffc        4 days ago          566.3 MB
    alyu/centos         pxc56               01eb2d9512be        4 days ago          1.059 GB

### Start 3 db instances

Launch 3 images named 'galera-1', 'galera-2', and 'galera-3' and map the host's
/mnt/data/{centos-pxc56|ubuntu-pxc56}/mysql to the instance's /var/lib/mysql direcory.

    $ ./start-servers.sh 3

    $ docker ps

    CONTAINER ID        IMAGE               COMMAND                CREATED             STATUS              PORTS                                                             NAMES
    7349a81d2294        alyu/centos:pxc56   /bin/bash /opt/init.   4 seconds ago       Up 2 seconds        22/tcp, 3306/tcp, 443/tcp, 4444/tcp, 4567/tcp, 4568/tcp, 80/tcp   galera-3
    862280f54f62        alyu/centos:pxc56   /bin/bash /opt/init.   4 seconds ago       Up 3 seconds        22/tcp, 3306/tcp, 443/tcp, 4444/tcp, 4567/tcp, 4568/tcp, 80/tcp   galera-2
    bcb8ea7da6c3        alyu/centos:pxc56   /bin/bash /opt/init.   4 seconds ago       Up 3 seconds        22/tcp, 3306/tcp, 443/tcp, 4444/tcp, 4567/tcp, 4568/tcp, 80/tcp   galera-1

### Bootstrap the Galera cluster

Sets a proper wsrep-cluster-address in each node's my.cnf file and performs a rolling restart
of the nodes so that they join the cluster.

    $ ./bootstrap-cluster.sh

### Login to the first node and check the cluster status

    $ ssh root@172.17.0.2 (pass: root123)
    $ mysql -uroot -proot123 -e "show status like '%wsrep%'"
