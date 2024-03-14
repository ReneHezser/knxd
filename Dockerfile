FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive

MAINTAINER Anders Åslund <anders.aslund@teknoir.se>

# Update packages
RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y \
      git-core \
      cmake \
      build-essential \
      wget \
      curl \
      debhelper \
      cdbs \
      autoconf \
      automake \
      libtool \
      libusb-1.0-0 \
      libusb-1.0-0-dev \
      pkg-config \
      libsystemd-dev \
      dh-systemd \
      init-system-helpers \
      libev-dev \
      libsystemd-dev \
      systemd \
 && apt-get clean -y \
 && apt-get autoclean -y \
 && apt-get autoremove

RUN dpkg --print-architecture

RUN if [ $(dpkg --print-architecture) = 'amd64' ]; then \
      echo "You are amd64"; \
    elif [ $(dpkg --print-architecture) = 'arm64' ]; then \
      echo "You are arm64"; \
    fi

RUN curl -o /usr/local/bin/gosu -sSL "https://github.com/tianon/gosu/releases/download/1.14/gosu-amd64" && \
	echo "bd8be776e97ec2b911190a82d9ab3fa6c013ae6d3121eea3d0bfd5c82a0eaf8c /usr/local/bin/gosu" | sha256sum -c && \
	chmod +x /usr/local/bin/gosu

# and get the source code
WORKDIR /root
RUN git clone https://github.com/knxd/knxd.git --single-branch --branch debian

# now build+install knxd itself
WORKDIR /root/knxd
RUN dpkg-buildpackage -b -uc
WORKDIR /root
RUN dpkg -i knxd_*.deb knxd-tools_*.deb

# clean up
RUN rm /root/*.deb && \
  rm /root/*.changes && \
  rm -rf /root/knxd && \
  rm -rf /usr/share/locale/* && \
  rm -rf /var/cache/debconf/*-old && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /usr/share/doc/*

ADD config.ini /config.ini

ENV GOSU_NAME docker

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh  \
    && sed -i -e 's/\r$//' /entrypoint.sh

COPY cmd.sh /
RUN chmod +x /cmd.sh  \
    && sed -i -e 's/\r$//' /cmd.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/cmd.sh"]
