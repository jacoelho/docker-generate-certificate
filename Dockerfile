FROM alpine

RUN apk --update --no-cache add openssl ca-certificates

ADD entrypoint.sh /entrypoint.sh

VOLUME [ "/certificates" ]

CMD [ "/entrypoint.sh" ]
