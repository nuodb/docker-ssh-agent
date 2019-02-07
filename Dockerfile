FROM alpine:latest

RUN apk add --no-cache \
    bash \
    openssh \
    socat \
    && rm -rf /var/cache/apk/*

COPY docker-entrypoint.sh /usr/local/bin

ENV SSH_DIR /.ssh
ENV SOCKET_DIR /.ssh-agent
ENV SSH_AUTH_SOCK ${SOCKET_DIR}/socket
ENV SSH_AUTH_PROXY_SOCK ${SOCKET_DIR}/proxy-socket

VOLUME ${SSH_DIR}
VOLUME ${SOCKET_DIR}

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["ssh-agent"]
