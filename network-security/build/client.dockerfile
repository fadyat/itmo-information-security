FROM ubuntu:20.04

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    nmap \
    net-tools \
    sudo \
    iputils-ping \
    telnet \
    curl && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get clean
