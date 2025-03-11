ARG S6_OVERLAY_VERSION=v3.2.0.0
FROM socheatsok78/s6-overlay-distribution:${S6_OVERLAY_VERSION} AS s6-overlay

FROM nginx:stable-alpine
COPY --link --from=s6-overlay / /

RUN apk add --no-cache \
    bash \
    fcgiwrap \
    git \
    git-daemon \
    git-gitweb \
    groff \
    highlight \
    lua5.3-libs \
    perl \
    perl-cgi \
    py3-markdown \
    py3-pygments \
    py3-docutils \
    spawn-fcgi \
    tzdata \
    xz \
    zlib

# Create git user and install gitolite
RUN <<EOF
    mkdir -p /var/lib/git
    addgroup -S git
    adduser -S -D -G git -h /var/lib/git git
EOF
ADD https://github.com/sitaramc/gitolite.git /var/lib/git/gitolite
RUN <<EOF
    cd /var/lib/git
    mkdir -p /var/lib/git/bin
    gitolite/install -to /var/lib/git/bin
    chown -R git:git /var/lib/git
EOF

# Switch back to root user
ADD rootfs /
ENTRYPOINT [ "/init-shim", "/docker-entrypoint-shim.sh" ]
CMD [ "nginx", "-g", "daemon off;" ]
STOPSIGNAL SIGTERM

VOLUME [ "/var/lib/git/repositories", "/var/cache/cgit" ]
WORKDIR /var/lib/git/repositories

EXPOSE 9418/tcp 9418/udp
