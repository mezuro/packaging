module GeneratePostInstall
  def generate_post_install(path, name, port)
    homedir = "/usr/share/mezuro/#{name}"
    configdir = "/etc/mezuro/#{name}"
    username = name.gsub('-', '_')

    File.open(path, 'w', 0755) do |script|
      script.write <<-__SCRIPT
#!/usr/bin/env bash

# Create system user
# Based on: https://github.com/salizzar/gordon/blob/master/lib/gordon/cookery/application_user.rb
/usr/bin/getent group #{username} >/dev/null || /usr/sbin/groupadd --system #{username}
/usr/bin/getent passwd #{username} >/dev/null || ( (/usr/sbin/useradd --system --gid #{username} --home-dir #{homedir} --shell /sbin/nologin #{username} >/dev/null || :; ) && chown -R #{username}:#{username} #{homedir} )

# Create postgresql user
systemctl start postgresql
sudo -u postgres psql -tAc \"SELECT 1 FROM pg_roles WHERE rolname='#{username}'\" | grep -q 1 || sudo -u postgres psql -c 'create role #{username} with createdb login'

cd #{homedir}
# Install gems from cache
bundle install --deployment --without development:test

# Setup database
if ! [ sudo -u postgres psql -lqt | cut -d \\| -f 1 | grep -w #{username}_production ]; then
  sudo -u #{username} RAILS_ENV=production bundle exec rake db:setup
else
  sudo -u #{username} RAILS_ENV=production bundle exec rake db:migrate
end

# Create systemd scripts
bundle exec foreman export systemd -a #{name} -u #{username} -p #{port} /usr/lib/systemd/system
sed -i 's/StopWhenUnneeded=true/StopWhenUnneeded=false/g' /usr/lib/systemd/system/#{name}.target

# Create secret token configuration file
SECRET=$(bundle exec rake secret)
sed -i \"s/<%= ENV\\[\\"SECRET_KEY_BASE\\"\\] %>/$SECRET/g\" #{configdir}/secrets.yml
  __SCRIPT
    end
  end
end
