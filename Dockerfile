FROM phusion/baseimage:bionic-1.0.0

LABEL maintainer="andrew-codechimp"

ENV DEBCONF_NONINTERACTIVE_SEEN="true" \
	DEBIAN_FRONTEND="noninteractive" \
	DISABLESSH="true" \
	HOME="/root" \
	LC_ALL="C.UTF-8" \
	LANG="en_US.UTF-8" \
	LANGUAGE="en_US.UTF-8" \
	TZ="Etc/UTC" \
	TERM="xterm" \
	SLIMUSER="nobody"

COPY init /etc/my_init.d/
COPY run /etc/service/lms/

RUN rm -rf /etc/service/cron /etc/service/syslog-ng

RUN	apt-get update && \
	apt-get -y upgrade -o Dpkg::Options::="--force-confold" && \
	apt-get -y dist-upgrade -o Dpkg::Options::="--force-confold" && \
	apt-get install -y lame faad flac sox perl wget tzdata pv && \
	apt-get install -y libio-socket-ssl-perl libcrypt-ssleay-perl && \
	apt-get install -y openssl libcrypt-openssl-bignum-perl libcrypt-openssl-random-perl libcrypt-openssl-rsa-perl

# Get latest build - no longer available for 7.9.2 but kept for future minor/major versions
# RUN	url="http://www.mysqueezebox.com/update/?version=7.9.2&revision=1&geturl=1&os=deb" && \
# 	latest_lms=$(wget -q -O - "$url") && \
# 	mkdir -p /sources && \
# 	cd /sources && \
# 	wget $latest_lms && \
# 	lms_deb=${latest_lms##*/} && \
# 	dpkg -i $lms_deb

# Get latest release 7.9.3
# RUN	lms_download_url="http://downloads.slimdevices.com/LogitechMediaServer_v7.9.3/logitechmediaserver_7.9.3_all.deb" && \
# 	mkdir -p /sources && \
# 	cd /sources && \
# 	wget $lms_download_url && \
# 	lms_deb=${lms_download_url##*/} && \
# 	dpkg -i $lms_deb

# Get latest build for 8.2.1
RUN	url="https://www.mysqueezebox.com/update/?version=8.2.1&revision=1&geturl=1&os=deb" && \
	latest_lms=$(wget -q -O - "$url") && \
	mkdir -p /sources && \
	cd /sources && \
	wget $latest_lms && \
	lms_deb=${latest_lms##*/} && \
	dpkg -i $lms_deb


RUN	chmod -R +x /etc/service/lms /etc/my_init.d/

RUN	ln -s /plugins/ /usr/sbin/Plugins

RUN	apt-get -y remove wget && \
	apt-get clean -y && \
	apt-get -y autoremove

VOLUME \
	["/config"] \
	["/music"] \
	["/plugins"]

EXPOSE 3483 3483/udp 9000 9090

CMD ["/sbin/my_init"]
