# Pull base image
FROM resin/rpi-raspbian:jessie
MAINTAINER Henrik Östman <trycoon@gmail.com>

ENV MOSQUITTO_VERSION 1.4.11
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install wget build-essential libwrap0-dev libssl-dev python-distutils-extra libc-ares-dev uuid-dev -y && \
    mkdir -p /usr/local/src && \
    cd /usr/local/src && \
    wget http://mosquitto.org/files/source/mosquitto-${MOSQUITTO_VERSION}.tar.gz && \
    tar xvzf ./mosquitto-${MOSQUITTO_VERSION}.tar.gz && \
    cd /usr/local/src/mosquitto-${MOSQUITTO_VERSION} && \
    make && make install && \
    cd /usr/local/src && \
    rm mosquitto-${MOSQUITTO_VERSION}.tar.gz && \
    apt-get autoremove wget build-essential libwrap0-dev libssl-dev python-distutils-extra libc-ares-dev uuid-dev -y

RUN adduser --system --disabled-password --disabled-login mosquitto

COPY config /mqtt/config
VOLUME ["/mqtt/config", "/mqtt/data", "/mqtt/log"]

EXPOSE 1883 9001
CMD /usr/sbin/mosquitto -c /mqtt/config/mosquitto.conf
