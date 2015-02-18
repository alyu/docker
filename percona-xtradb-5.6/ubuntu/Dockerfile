# Percona XtraDB Cluster 5.6
#
# VERSION 1.0
# DOCKER-VERSION 0.81
#
# tag: latest
FROM ubuntu:latest
MAINTAINER Alex Yu <alex@alexyu.se>

RUN echo 'root:root123' | chpasswd
RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get -y -f install openssh-server openssh-client
#RUN sed -ri 's/#PermitRootLogin yes/PermitRootLogin yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config
RUN mkdir -p /var/run/sshd
RUN mkdir -p /root/.ssh; chmod 700 /root/.ssh
ADD id_rsa.pub /root/.ssh/authorized_keys
RUN chown root.root /root/.ssh/*; chmod 600 /root/.ssh/*

# supervisord for sshd
RUN apt-get -y install supervisor
ADD supervisord.conf /etc/supervisor/conf.d/
RUN chown root.root /etc/supervisor/conf.d/supervisord.conf

RUN apt-key adv --keyserver keys.gnupg.net --recv-keys 1C4CBDCDCD2EFD2A 
RUN echo "deb http://repo.percona.com/apt precise main" > /etc/apt/sources.list.d/percona.list
RUN apt-get update; apt-get -y install qpress percona-xtradb-cluster-56
RUN rm -rf /var/lib/mysql/* /var/run/mysqld/* /etc/my.cnf
ADD my.cnf /etc/mysql/my.cnf
RUN chown mysql.mysql /etc/mysql/my.cnf
RUN apt-get -y install sysbench

EXPOSE 22 80 443 3306 4444 4567 4568

ADD init.sh /opt/init.sh
RUN chown root.root /opt/init.sh
CMD ["/bin/bash", "/opt/init.sh"]

