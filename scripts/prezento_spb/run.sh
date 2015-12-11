#!/bin/bash

set -ex

if which yum >/dev/null 2>&1; then
  yum install -y "$@"
elif which dpkg >/dev/null 2>&1; then
  dpkg -i "$@"
else
  echo "Unknown operating system" >&2
  exit 1
fi

git config --global http.sslverify false # Enables SPB repo clonning through http
fpm-cook package --pkg-dir /root/mezuro/pkgs/prezento-spb /root/mezuro/scripts/prezento_spb/recipe.rb
