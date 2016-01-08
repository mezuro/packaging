#!/bin/bash

set -ex

git config --global http.sslverify false # Enables SPB repo clonning through http
fpm-cook package --pkg-dir /root/mezuro/pkgs/prezento-spb /root/mezuro/scripts/prezento_spb/recipe.rb
