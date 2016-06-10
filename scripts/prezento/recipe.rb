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

  revision MezuroInformations::PREZENTO[:info][:release]

  config_files '/etc/mezuro/prezento/database.yml', '/etc/mezuro/prezento/secrets.yml'

  directories '/usr/share/mezuro/prezento'

  case platform
  when :centos
    then
    depends 'postgresql', 'postgresql-server', 'ruby', 'ruby-devel', 'gcc', 'gcc-c++', 'patch', 'zlib-devel', 'rubygem-bundler', 'sqlite-devel', 'postgresql-devel', 'redhat-rpm-config', 'kalibro-processor', 'kalibro-configurations', 'libxml2-devel', 'libxslt-devel'
  when :debian
    then
    depends 'postgresql', 'ruby', 'bundler', 'libsqlite3-dev', 'postgresql-server-dev-9.4', 'kalibro-processor', 'kalibro-configurations', 'libxml2-dev', 'libxslt1-dev'
  end

  post_install "post_install.sh"
  post_uninstall 'post_uninstall.sh'

  def build
    inline_replace 'config/database.yml.postgresql_sample' do |s|
      s.gsub! /^(\s*)username:(.*)/, ''
      s.gsub! /^(\s*)password:(.*)/, ''
    end

    generate_script(workdir("../post_install.sh"), workdir("post_install.sh"), 'prezento', 8081)
    generate_script(workdir('../post_uninstall.sh'), workdir('post_uninstall.sh'), 'prezento', nil)
    generate_script(workdir("../admin.sh"), builddir("admin.sh"), 'prezento', nil)

    safesystem("bundle package --all --all-platforms")
  end

  def install
    var('tmp/mezuro/prezento').mkdir
    var('log/mezuro/prezento').mkdir
    rm_rf 'log'
    etc('mezuro/prezento').install 'config/database.yml.postgresql_sample', 'database.yml'
    etc('mezuro/prezento').install 'config/secrets.yml', 'secrets.yml'
    etc('mezuro/prezento').install 'config/kalibro.yml.sample', 'kalibro.yml'
    rm 'config/secrets.yml'
    share('mezuro/prezento').install Dir['*']
    ln_s '/var/tmp/mezuro/prezento', share('mezuro/prezento/tmp')
    ln_s '/var/log/mezuro/prezento', share('mezuro/prezento/log')
    ln_s '/etc/mezuro/prezento/database.yml', share('mezuro/prezento/config/database.yml')
    ln_s '/etc/mezuro/prezento/secrets.yml', share('mezuro/prezento/config/secrets.yml')
    ln_s '/etc/mezuro/prezento/kalibro.yml', share('mezuro/prezento/config/kalibro.yml')
    share('mezuro/prezento').install %w(.bundle .env)
    bin.install builddir('admin.sh'), 'prezento-admin'
  end
end
