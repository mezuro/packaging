require_relative '../generate_post_install'

class Prezento < FPM::Cookery::Recipe
  include GeneratePostInstall

  name     'prezento'
  version  '0.9.2'
  source   'https://github.com/mezuro/prezento.git', :with => :git, :tag => "v#{version}"

  maintainer  'Mezuro Team <mezurometrics@gmail.com>'
  license     'AGPLv3'
  description 'Collaborative code metrics'
  arch        'all'

  revision '1'

  config_files '/etc/mezuro/prezento/database.yml', '/etc/mezuro/prezento/secrets.yml'

  case platform
  when :centos
    then
    depends 'postgresql', 'postgresql-server', 'ruby', 'ruby-devel', 'gcc', 'gcc-c++', 'patch', 'zlib-devel', 'rubygem-bundler', 'sqlite-devel', 'postgresql-devel', 'redhat-rpm-config', 'kalibro-processor', 'kalibro-configurations'
  when :debian
    then
    depends 'postgresql', 'ruby', 'bundler', 'libsqlite3-dev', 'postgresql-server-dev-9.4', 'kalibro-processor', 'kalibro-configurations'
  end

  post_install "post_install.rb"

  def build
    inline_replace 'config/database.yml.postgresql_sample' do |s|
      s.gsub! /^(\s*)username:(.*)/, ''
      s.gsub! /^(\s*)password:(.*)/, ''
    end

    generate_post_install("#{File.dirname(__FILE__)}/post_install.rb", 'prezento', 8081)

    safesystem("bundle package --all --all-platforms")
  end

  def install
    etc('mezuro/prezento').install 'config/database.yml.postgresql_sample', 'database.yml'
    ln_s '/etc/mezuro/prezento/database.yml', 'config/database.yml'
    etc('mezuro/prezento').install 'config/secrets.yml', 'secrets.yml'
    rm 'config/secrets.yml'
    ln_s '/etc/mezuro/prezento/secrets.yml', 'config/secrets.yml'
    share('mezuro/prezento').install Dir['*']
    share('mezuro/prezento').install %w(.bundle .env)
  end
end