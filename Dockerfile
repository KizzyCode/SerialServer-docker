# Build the daemon
FROM ghcr.io/kizzycode/buildbase-rust:tumbleweed AS buildenv

RUN mv /root/.cargo /root/.cargo-tmp
RUN --mount=type=tmpfs,target=/root/.cargo \
    cp -r /root/.cargo-tmp/* /root/.cargo \
    && cargo install --git https://github.com/KizzyCode/SerialServer-rust --branch bug/linux-compat \
    && cp /root/.cargo/bin/serial-server /root/serial-server


# Build the real container
FROM opensuse/tumbleweed:latest

RUN zypper install --no-confirm gettext

COPY --from=buildenv /root/serial-server /usr/local/bin/serial-server
COPY ./files/serial-server.toml.template /etc/serial-server.toml.template
COPY ./files/start.sh /usr/libexec/start.sh

USER root
CMD [ "/usr/libexec/start.sh" ]
