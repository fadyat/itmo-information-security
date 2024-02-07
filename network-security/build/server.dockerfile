FROM ubuntu:20.04

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    nmap \
    tshark \
    apt-utils \
    net-tools \
    ufw \
    sudo \
    netcat \
    less \
    snort && \
    rm -rf /var/lib/apt/lists/*

COPY http /exec/http
RUN chmod +x /exec/http

RUN apt-get clean

ENTRYPOINT ["/exec/http"]
