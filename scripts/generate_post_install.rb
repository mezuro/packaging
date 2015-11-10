module GeneratePostInstall
  def generate_post_install(path, name, port)
    homedir = "/usr/share/mezuro/#{name}"
    configdir = "/etc/mezuro/#{name}"
    username = name.gsub('-', '_')

    File.open(path, 'w', 0755) do |script|
      script.write <<-__SCRIPT
#!/usr/bin/env ruby

# Create system user
# Based on: https://github.com/salizzar/gordon/blob/master/lib/gordon/cookery/application_user.rb
system("/usr/sbin/groupadd --system #{username}") unless system("/usr/bin/getent group #{username} >/dev/null")
unless system("/usr/bin/getent passwd #{username} >/dev/null")
  system("/usr/sbin/useradd --system --gid #{username} --home-dir #{homedir} --shell /sbin/nologin #{username} >/dev/null || :;")
  system('chown -R #{username}:#{username} #{homedir}')
end

# Create postgresql user
unless system("sudo -u postgres psql -tAc \\"SELECT 1 FROM pg_roles WHERE rolname='#{username}'\\" | grep -q 1")
  system("sudo -u postgres psql -c 'create role #{username} with createdb login'")
end

Dir.chdir('#{homedir}') do
  system("bundle install --deployment --without development:test")

  unless system('sudo -u postgres psql -lqt | cut -d \\| -f 1 | grep -w #{username}_production')
    system("sudo -u #{username} RAILS_ENV=production bundle exec rake db:setup")
  else
    system("sudo -u #{username} RAILS_ENV=production bundle exec rake db:migrate")
  end

  system('bundle exec foreman export systemd -a #{name} -u #{username} -p #{port} /usr/lib/systemd/system')
  main_target = File.read("/usr/lib/systemd/system/#{name}.target")
  main_target.gsub! 'StopWhenUnneeded=true', 'StopWhenUnneeded=false'
  File.open('/usr/lib/systemd/system/#{name}.target', 'w') { |file| file.puts main_target }

  secret = `bundle exec rake secret`
  secrets = File.read('#{configdir}/secrets.yml')
  secrets.gsub! '<%= ENV["SECRET_KEY_BASE"] %>', secret
  File.open('#{configdir}/secrets.yml', 'w') { |file| file.puts secrets }
end
  __SCRIPT
    end
  end
end
