#!/bin/bash

cd /root/mezuro/pkgs/kalibro_configurations
echo "web: bundle exec rails s -p 8083" > /root/mezuro/src/kalibro_configurations/Procfile
pkgr package /root/mezuro/src/kalibro_configurations &> log
