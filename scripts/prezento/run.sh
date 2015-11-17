#!/bin/bash

systemctl start postgresql
fpm-cook package --pkg-dir /root/mezuro/pkgs/prezento /root/mezuro/scripts/prezento/recipe.rb
