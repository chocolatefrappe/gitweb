#!/bin/bash
set -x

chown -R git:git /var/lib/git || true
chmod -R 755 /var/lib/git/repositories || true
