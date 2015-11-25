require_relative '../generate_post_install'

class KalibroConfigurations < FPM::Cookery::Recipe
  include GeneratePostInstall

  name     'kalibro-configurations'
  version  '1.2.3'
  source   'https://github.com/mezuro/kalibro_configurations.git', :with => :git, :tag => "v#{version}"

  maintainer  'Mezuro Team <mezurometrics@gmail.com>'
  license     'AGPLv3'
  description 'Web service for managing code analysis configurations'
  arch        'all'

  revision '1'

  config_files '/etc/mezuro/kalibro-configurations/database.yml', '/etc/mezuro/kalibro-configurations/secrets.yml'

  case platform
  when :centos
    then
    depends 'postgresql', 'postgresql-server', 'ruby', 'ruby-devel', 'gcc', 'gcc-c++', 'patch', 'zlib-devel', 'rubygem-bundler', 'sqlite-devel', 'postgresql-devel', 'redhat-rpm-config'
  when :debian
    then
    depends 'postgresql', 'ruby', 'bundler', 'libsqlite3-dev', 'postgresql-server-dev-9.4'
  end

  post_install "post_install.sh"

  def build
    inline_replace 'config/database.yml.postgresql_sample' do |s|
      s.gsub! /^(\s*)username:(.*)/, ''
      s.gsub! /^(\s*)password:(.*)/, ''
    end

    generate_post_install("#{File.dirname(__FILE__)}/post_install.sh", 'kalibro-configurations', 8083)

    safesystem("bundle package --all --all-platforms")
  end

  def install
    etc('mezuro/kalibro-configurations').install 'config/database.yml.postgresql_sample', 'database.yml'
    ln_s '/etc/mezuro/kalibro-configurations/database.yml', 'config/database.yml'
    etc('mezuro/kalibro-configurations').install 'config/secrets.yml', 'secrets.yml'
    rm 'config/secrets.yml'
    ln_s '/etc/mezuro/kalibro-configurations/secrets.yml', 'config/secrets.yml'
    share('mezuro/kalibro-configurations').install Dir['*']
    share('mezuro/kalibro-configurations').install %w(.bundle .env)
  end
end
