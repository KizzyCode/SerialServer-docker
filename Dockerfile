# Build the daemon
FROM ghcr.io/kizzycode/buildbase-rust:ubuntu AS buildenv

RUN mv /root/.cargo /root/.cargo-persistent
RUN --mount=type=tmpfs,target=/root/.cargo \
    cp -a /root/.cargo-persistent/. /root/.cargo \
    && /root/.cargo/bin/cargo install --git https://github.com/KizzyCode/SerialServer-rust --branch bug/linux-compat \
    && cp /root/.cargo/bin/serial-server /root/serial-server


# Build the real container
FROM ubuntu:latest

ENV APT_PACKAGES gettext
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update \
    && apt-get upgrade --yes \
    && apt-get install --yes ${APT_PACKAGES} \
    && apt-get autoremove --yes \
    && apt-get clean

COPY --from=buildenv /root/serial-server /usr/local/bin/serial-server
COPY ./files/serial-server.toml.template /etc/serial-server.toml.template
COPY ./files/start.sh /usr/libexec/start.sh

USER root
CMD [ "/usr/libexec/start.sh" ]
