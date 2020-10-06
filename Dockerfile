FROM debian:jessie
MAINTAINER Jerry <mcchae@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y && \
      apt-get upgrade -y && \
      apt-get install -y --no-install-recommends \
        --no-install-suggests \
        bind9

RUN mkdir -p /var/run/named /etc/bind/zones && \
      chmod 775 /var/run/named && \
      chown root:bind /var/run/named > /dev/nul 2>&1

RUN apt-get clean && \
      apt-get autoremove --purge -y && \
      rm -rf /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/* \
        /usr/share/man/??_* \
        /usr/share/man/??

VOLUME ["/etc/bind", "/var/cache/bind", "/var/lib/bind", "/var/log", "/var/run/named"]

EXPOSE 53



RUN echo root:pass | chpasswd && \
        echo "Acquire::GzipIndexes \"false\"; Acquire::CompressionTypes::Order:: \"gz\";" >/etc/apt/apt.conf.d/docker-gzip-indexes && \
        apt-get update && \
        apt-get install -y \
        wget \
        locales && \
        dpkg-reconfigure locales && \
        locale-gen C.UTF-8 && \
        /usr/sbin/update-locale LANG=C.UTF-8 && \
        wget http://www.webmin.com/jcameron-key.asc && \
        apt-key add jcameron-key.asc && \
        echo "deb http://download.webmin.com/download/repository sarge contrib" >> /etc/apt/sources.list && \
        echo "deb http://webmin.mirror.somersettechsolutions.co.uk/repository sarge contrib" >> /etc/apt/sources.list && \
        apt-get update && \
        apt-get install -y webmin && \
        apt-get clean


ENV LC_ALL C.UTF-8

EXPOSE 10000

VOLUME ["/etc/webmin"]


CMD /usr/bin/touch /var/webmin/miniserv.log && /usr/sbin/service webmin restart && /usr/sbin/named -g -c /etc/bind/named.conf -u bind
