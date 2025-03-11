ARG S6_OVERLAY_VERSION=v3.2.0.0
FROM socheatsok78/s6-overlay-distribution:${S6_OVERLAY_VERSION} AS s6-overlay

FROM nginx:stable-alpine
COPY --link --from=s6-overlay / /

RUN apk add --no-cache \
    bash \
    cgit \
    fcgiwrap \
    git \
    git-daemon \
    git-gitweb \
    groff \
    highlight \
    inotify-tools \
    lua5.3-libs \
    perl \
    perl-cgi \
    py3-markdown \
    py3-pygments \
    py3-docutils \
    spawn-fcgi \
    tzdata \
    xz \
    zlib \
    && cp -r /usr/lib/cgit/ /usr/lib/gitweb/ \
    && apk del cgit

# Create git user and group
RUN <<EOF
    mkdir -p /var/lib/git
    addgroup -S -g 102 git
    adduser -S -D -G git -h /var/lib/git -u 102 git
    chown -R git:git /var/lib/git
EOF

ADD rootfs /
ENTRYPOINT [ "/init-shim", "/docker-entrypoint-shim.sh" ]
CMD [ "nginx", "-g", "daemon off;" ]
STOPSIGNAL SIGTERM

VOLUME [ "/var/lib/git/repositories", "/var/cache/cgit" ]
WORKDIR /var/lib/git/repositories

# The following ports are exposed by default
# The git:// protocol is served by the git-daemon service on port 9418
EXPOSE 9418/tcp 9418/udp
