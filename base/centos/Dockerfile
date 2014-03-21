# Base centos image
#
# VERSION 1.0
# DOCKER-VERSION 0.9x
#
# tag: latest
FROM centos:latest
MAINTAINER Alex Yu <alex@alexyu.se>

RUN yum -y update
RUN echo 'root:root123' | chpasswd
RUN yum -y install openssh-server openssh-clients which sudo
# unsafe
#RUN sed -ri 's/#PermitRootLogin yes/PermitRootLogin yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config
RUN mkdir -p /root/.ssh; chmod 700 /root/.ssh
ADD id_rsa.pub /root/.ssh/authorized_keys
RUN chown root.root /root/.ssh/*; chmod 600 /root/.ssh/*
ADD src/nopasswd /etc/sudoers.d/nopasswd
RUN chown root.root /etc/sudoers.d/*

# supervisord for sshd
RUN yum -y install python-setuptools
RUN easy_install supervisor
ADD src/supervisord.conf /etc/
RUN chown root.root /etc/supervisord.conf

EXPOSE 22 80 443 3306 4444 4567 4568 27017 27018 27019 28017

ADD src/init.sh /opt/init.sh
RUN chown root.root /opt/init.sh
CMD ["/bin/bash", "/opt/init.sh"]

