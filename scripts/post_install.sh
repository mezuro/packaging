#!/usr/bin/env bash

set -e

name=
username=
port=
homedir=
configdir=

admin_bin="${name}-admin"

# Create system user
# Based on: https://github.com/salizzar/gordon/blob/master/lib/gordon/cookery/application_user.rb
getent group ${username} >/dev/null || groupadd --system ${username}
if ! getent passwd ${username} >/dev/null; then
  useradd --system --gid ${username} --home-dir ${homedir} --shell /sbin/nologin ${username} >/dev/null
  chown -R ${username}:${username} ${homedir}
fi

cd ${homedir}
# Install gems from cache
bundle install --deployment --without development:test > /dev/null

# Check if the service is running
WAS_RUNNING=0
if systemctl is-active --quiet ${name}.target; then
  systemctl stop ${name}.target
  WAS_RUNNING=1
fi

# Create systemd scripts
bundle exec foreman export systemd -a ${name} -u ${username} -p ${port} /usr/lib/systemd/system
sed -i 's/StopWhenUnneeded=true/StopWhenUnneeded=false/g' /usr/lib/systemd/system/${name}.target

# Create secret token configuration file
SECRET=$(bundle exec rake secret)
sed -i "s/<%= ENV\[\"SECRET_KEY_BASE\"\] %>/$SECRET/g" ${configdir}/secrets.yml

# Create postgresql user
if systemctl start postgresql; then
  sleep 2
  if ! sudo -u postgres psql -tAc "SELECT 1 FROM pg_roles WHERE rolname='${username}'" | grep -q 1; then
    sudo -u postgres psql -c "create role ${username} with createdb login" || :
  fi

  # Setup database
  if ! sudo -u postgres psql -lqt | cut -d '|' -f 1 | grep -qw "${username}_production"; then
    $admin_bin rake db:create > /dev/null || :
    $admin_bin rake db:migrate > /dev/null || :

    cat <<EOF
${name} database successfully created. If you want to populate it with default data, please run `$admin_bin rake db:seed`.
NOTICE: errors may be risen if the required services are not running.
EOF
  fi
fi

# Restart the service if it was running
if [ $WAS_RUNNING -ne 0 ]; then
  systemctl start ${name}.target || :
fi
