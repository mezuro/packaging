require_relative '../generate_script'
require_relative '../../mezuro_informations'

class Prezento < FPM::Cookery::Recipe
  include GenerateScript

  name     MezuroInformations::PREZENTO[:data][:name]
  version  MezuroInformations::PREZENTO[:info][:version]
  source   MezuroInformations::PREZENTO[:data][:vcs_url], :with => :git, :tag => "v#{version}"

  maintainer  'Mezuro Team <mezurometrics@gmail.com>'
  license     MezuroInformations::PREZENTO[:data][:licenses][0]
  description MezuroInformations::PREZENTO[:data][:desc]
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

  post_install "post_install.sh"

  def build
    inline_replace 'config/database.yml.postgresql_sample' do |s|
      s.gsub! /^(\s*)username:(.*)/, ''
      s.gsub! /^(\s*)password:(.*)/, ''
    end

    generate_script(workdir("../post_install.sh"), workdir("post_install.sh"), 'prezento', 8081)
    generate_script(workdir("../admin.sh"), builddir("admin.sh"), 'prezento', nil)

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
    bin.install builddir('admin.sh'), 'prezento-admin'
  end
end
