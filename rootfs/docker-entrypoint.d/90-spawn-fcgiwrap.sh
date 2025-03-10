#!/bin/bash
spawn-fcgi -s /var/run/fcgiwrap.socket /usr/bin/fcgiwrap
chown nginx:nginx /var/run/fcgiwrap.socket
