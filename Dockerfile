FROM phusion/baseimage:0.9.19
MAINTAINER janwer <mail@janwerner.de>
ENV DEBIAN_FRONTEND noninteractive

#Disable the SSH server
RUN rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh

# Set correct environment variables.
ENV HOME /root


# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

#Change uid & gid to match Unraid
RUN usermod -u 99 nobody && \
    usermod -g 100 nobody

RUN apt-add-repository multiverse && \
    apt-get update -qq && \
    apt-get install -qy mono-complete sudo unzip wget nano

#Download and extract WG++ to correct paths
RUN mkdir /webgrab && \
    wget -O /tmp/webgrab.tar.gz http://webgrabplus.com/sites/default/files/download/SW/V2.0.0/WebGrabPlus_V2.0_install.tar.gz && \
    wget -O /tmp/siteini.zip http://webgrabplus.com/sites/default/files/download/ini/SiteIniPack_current.zip && \
    tar --strip-components=1 -xvf /tmp/webgrab.tar.gz -C /webgrab && \
    rm -rf /webgrab/siteini.pack && \
    unzip -o -d /webgrab /tmp/siteini.zip && \
    rm -f /tmp/webgrab.tar.gz /tmp/siteini.zip && \
    cd /webgrab && \
    ./install.sh && \
    rm -f /webgrab/WebGrab++.config.xml /webgrab/WebGrab++.config.example.xml

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

#Add scripts & config
ADD ./assets/startup.sh ./assets/mycron ./assets/WebGrab++.config.xml /webgrab/assets/
RUN chmod -R +x /webgrab/ && \
    crontab -u nobody /webgrab/assets/mycron && \
    mkdir -p /etc/my_init.d && \
    cp /webgrab/assets/startup.sh /etc/my_init.d/ 

VOLUME /config \
       /data
