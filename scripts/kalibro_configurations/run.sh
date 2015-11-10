#!/bin/bash

service postgresql start
fpm-cook package -p centos --pkg-dir /root/mezuro/pkgs/kalibro_configurations /root/mezuro/scripts/kalibro_configurations/recipe.rb
fpm-cook clean /root/mezuro/scripts/kalibro_configurations/recipe.rb
fpm-cook package -p debian --pkg-dir /root/mezuro/pkgs/kalibro_configurations /root/mezuro/scripts/kalibro_configurations/recipe.rb
