FROM centos:6
MAINTAINER "Marek Skrobacki <skrobul@skrobul.com>"

# Zenoss-core version to install
ENV VERSION=4.2.3
RUN yum install -y wget git byobu ntpdate htop unzip vim-enhanced fping nmap tar
RUN echo 'alias vi=vim' > /etc/profile.d/vi-vim.sh

RUN cd /tmp/ && \
    wget --no-check-certificate https://github.com/skrobul/core-autodeploy/tarball/$VERSION -O auto.tar.gz && \
    tar xvf auto.tar.gz
RUN cd /tmp/skrobul-core-autodeploy-* && ./core-autodeploy.sh
ADD start_zenoss.sh /
RUN chmod +x /start_zenoss.sh
EXPOSE 8080
EXPOSE 514
EXPOSE 162
EXPOSE 11211
CMD /start_zenoss.sh
