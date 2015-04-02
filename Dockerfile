FROM debian:stable

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates openssl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD entrypoint.sh /entrypoint.sh

VOLUME [ "/certificates" ]

CMD [ "/entrypoint.sh" ]
