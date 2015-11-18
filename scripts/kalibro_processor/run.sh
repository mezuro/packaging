#!/bin/bash

systemctl start postgresql
fpm-cook package --pkg-dir /root/mezuro/pkgs/kalibro_processor /root/mezuro/scripts/kalibro_processor/recipe.rb
