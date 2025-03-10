FROM nginx:stable-alpine
RUN apk add --no-cache bash fcgiwrap spawn-fcgi git git-daemon git-gitweb perl perl-cgi highlight
ADD rootfs /
VOLUME [ "/data" ]
