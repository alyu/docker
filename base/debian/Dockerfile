# Default debian image
#
# VERSION 1.0
# DOCKER-VERSION 0.9x
#
# tag: latest
FROM debian:latest
MAINTAINER Alex Yu <alex@alexyu.se>

ENV DEBIAN_FRONTEND noninteractive
ENV INITRD No
ENV FAKE_CHROOT 1
RUN mv /usr/bin/ischroot /usr/bin/ischroot.original
ADD src/ischroot /usr/bin/ischroot
ADD src/policy-rc.d /usr/sbin/policy-rc.d
RUN echo 'force-unsafe-io' | tee /etc/dpkg/dpkg.cfg.d/02apt-speedup
RUN echo 'DPkg::Post-Invoke {"/bin/rm -f /var/cache/apt/archives/*.deb || true";};' | tee /etc/apt/apt.conf.d/no-cache
RUN apt-get -y install apt-utils && apt-get -y update && apt-get -y dist-upgrade
RUN apt-get clean
RUN rm -rf /var/cache/apt/* 

RUN echo 'root:root123' | chpasswd
RUN apt-get -y -f install openssh-server openssh-client sudo net-tools vim
#RUN sed -ri 's/#PermitRootLogin yes/PermitRootLogin yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config
RUN mkdir -p /var/run/sshd
RUN mkdir -p /root/.ssh; chmod 700 /root/.ssh
ADD id_rsa.pub /root/.ssh/authorized_keys
RUN chown root.root /root/.ssh/*; chmod 600 /root/.ssh/*
ADD src/nopasswd /etc/sudoers.d/nopasswd
RUN chown root.root /etc/sudoers.d/*

# supervisord for sshd
RUN apt-get -y install supervisor
ADD src/supervisord.conf /etc/supervisor/conf.d/
RUN chown root.root /etc/supervisor/conf.d/supervisord.conf

EXPOSE 22 80 443 3306 4444 4567 4568 27017 27018 27019 28017

ADD src/init.sh /opt/init.sh
RUN chown root.root /opt/init.sh
CMD ["/bin/bash", "/opt/init.sh"]

