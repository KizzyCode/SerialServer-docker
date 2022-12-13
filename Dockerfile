# Build the daemon
FROM alpine:edge AS buildenv

RUN apk add --no-cache build-base cargo git rust
RUN cargo install --config=net.git-fetch-with-cli=true \
    --git https://github.com/KizzyCode/SerialServer-rust --branch bug/linux-compat


# Build the real container
FROM alpine:latest

RUN apk add --no-cache gettext

COPY --from=buildenv /root/.cargo/bin/serial-server /usr/local/bin/serial-server
COPY ./files/serial-server.toml.template /etc/serial-server.toml.template
COPY ./files/start.sh /usr/libexec/start.sh

USER root
CMD [ "/usr/libexec/start.sh" ]
