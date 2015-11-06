module GeneratePostInstall
  def generate_post_install(path, name)
    homedir = "/usr/share/mezuro/#{name}"
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
  system("sudo -u #{username} RAILS_ENV=production bundle exec rake db:setup")
end
__SCRIPT
    end
  end
end
