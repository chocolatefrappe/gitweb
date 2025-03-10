FROM nginx:stable-alpine
RUN apk add --no-cache bash fcgiwrap spawn-fcgi git git-daemon git-gitweb perl perl-cgi highlight
ADD rootfs /

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
USER root
VOLUME [ "/data" ]
WORKDIR /data
