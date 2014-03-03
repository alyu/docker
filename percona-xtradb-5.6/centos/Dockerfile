# Percona XtraDB Cluster 5.6
#
# VERSION 1.0
# DOCKER-VERSION 0.81
#
# tag: latest
FROM centos:latest
MAINTAINER Alex Yu <alex@alexyu.se>

RUN yum -y update
RUN echo 'root:root123' | chpasswd
RUN yum -y install openssh-server openssh-clients which
# unsafe
#RUN sed -ri 's/#PermitRootLogin yes/PermitRootLogin yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config
RUN mkdir -p /root/.ssh; chmod 700 /root/.ssh
ADD id_rsa.pub /root/.ssh/authorized_keys
RUN chown root.root /root/.ssh/*; chmod 600 /root/.ssh/*

# supervisord for sshd
RUN yum -y install python-setuptools
RUN easy_install supervisor
ADD supervisord.conf /etc/
RUN chown root.root /etc/supervisord.conf

# epel
RUN wget http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
RUN wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
RUN rpm -Uvh epel* remi-*

# PXC XtraDB 5.6
RUN rpm -Uhv http://www.percona.com/downloads/percona-release/percona-release-0.0-1.x86_64.rpm
RUN yum -y remove mysql-*
# need epel for qpress
RUN yum -y install Percona-XtraDB-Cluster-56 qpress
RUN rm -rf /var/lib/mysql/* /var/run/mysqld/* /etc/my.cnf
ADD my.cnf /etc/my.cnf
RUN chown mysql.mysql /etc/my.cnf

# sysbench need libaio and libmysqlclient
RUN yum -y install libaio
RUN wget http://www.lefred.be/files/sysbench-0.5-3.el6_.x86_64.rpm
RUN rpm -Uvh sysb*
RUN rm -f *.rpm

EXPOSE 22 80 443 3306 4444 4567 4568

ADD init.sh /opt/init.sh
RUN chown root.root /opt/init.sh
CMD ["/bin/bash", "/opt/init.sh"]

