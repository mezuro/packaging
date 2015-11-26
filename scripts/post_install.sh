#!/usr/bin/env bash

name=
port=
homedir=
configdir=
username=

# Create system user
# Based on: https://github.com/salizzar/gordon/blob/master/lib/gordon/cookery/application_user.rb
/usr/bin/getent group ${username} >/dev/null || /usr/sbin/groupadd --system ${username}
/usr/bin/getent passwd ${username} >/dev/null || ( (/usr/sbin/useradd --system --gid ${username} --home-dir ${homedir} --shell /sbin/nologin ${username} >/dev/null || :; ) && chown -R ${username}:${username} ${homedir} )

# Create postgresql user
systemctl start postgresql
sudo -u postgres psql -tAc "SELECT 1 FROM pg_roles WHERE rolname='${username}'" | grep -q 1 || sudo -u postgres psql -c 'create role ${username} with createdb login'

cd ${homedir}
# Install gems from cache
bundle install --deployment --without development:test > /dev/null

# Check if the service is running
WAS_RUNNING=0
if [ `systemctl status ${name}.target | grep running > /dev/null` ]; then
  systemctl stop ${name}.target
  WAS_RUNNING=1
fi

# Setup database
if ! [ `sudo -u postgres psql -lqt | cut -d '|' -f 1 | grep -w ${username}_production` ]; then
  sudo -u ${username} RAILS_ENV=production bundle exec rake db:create > /dev/null
  echo "\n"
  echo "${name} database successfully created. If you want to populate it with default data, please run the following commands:"
  echo "\n"
  echo "\t cd ${homedir}"
  echo "\t sudo -u ${username} RAILS_ENV=production bundle exec rake db:seed"
  echo "\n"
  echo "NOTICE: errors may be risen if the required services are not running."
  echo "\n"
fi
sudo -u ${username} RAILS_ENV=production bundle exec rake db:migrate > /dev/null

# Create systemd scripts
bundle exec foreman export systemd -a ${name} -u ${username} -p ${port} /usr/lib/systemd/system
sed -i 's/StopWhenUnneeded=true/StopWhenUnneeded=false/g' /usr/lib/systemd/system/${name}.target

# Restart the service if it was running
if [ $WAS_RUNNING -ne 0 ]; then
  systemctl start ${name}.target
fi

# Create secret token configuration file
SECRET=$(bundle exec rake secret)
sed -i 's/<%= ENV\["SECRET_KEY_BASE"\] %>/'"$SECRET"'/g' ${configdir}/secrets.yml
