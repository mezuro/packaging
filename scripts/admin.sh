#!/usr/bin/env bash

name=
username=
port=
homedir=
configdir=

[ "$USER" = "$username" ] || exec sudo -u "$username" "$0" "$@"

cd "$homedir"
RAILS_ENV=production exec bundle exec "$@"
