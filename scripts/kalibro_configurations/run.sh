#!/bin/bash

service postgresql start
fpm-cook package --pkg-dir /root/mezuro/pkgs/kalibro_configurations /root/mezuro/scripts/kalibro_configurations/recipe.rb
