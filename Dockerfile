ARG S6_OVERLAY_VERSION=v3.2.0.0
FROM socheatsok78/s6-overlay-distribution:${S6_OVERLAY_VERSION} AS s6-overlay

FROM nginx:stable-alpine
COPY --link --from=s6-overlay / /

RUN apk add --no-cache bash fcgiwrap spawn-fcgi git git-daemon git-gitweb perl perl-cgi highlight

# Create git user and install gitolite
RUN <<EOF
    mkdir -p /var/lib/git
    addgroup -S git
    adduser -S -D -G git -h /var/lib/git git
EOF
USER git
ADD https://github.com/sitaramc/gitolite.git /var/lib/git/gitolite
RUN <<EOF
    cd /var/lib/git
    mkdir -p /var/lib/git/bin
    gitolite/install -to /var/lib/git/bin
EOF

# Switch back to root user
ADD rootfs /
ENTRYPOINT [ "/init-shim" ]
CMD [ "sleep", "infinity" ]

USER root
VOLUME [ "/data" ]
WORKDIR /data

EXPOSE 9418/tcp 9418/udp
