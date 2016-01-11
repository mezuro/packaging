require_relative '../generate_script'
require_relative '../../mezuro_informations'

class KalibroConfigurations < FPM::Cookery::Recipe
  include GenerateScript

  name     MezuroInformations::KALIBRO_CONFIGURATIONS[:data][:name]
  version  MezuroInformations::KALIBRO_CONFIGURATIONS[:info][:version]
  source   MezuroInformations::KALIBRO_CONFIGURATIONS[:data][:vcs_url], :with => :git, :tag => "v#{version}"

  maintainer  'Mezuro Team <mezurometrics@gmail.com>'
  license     MezuroInformations::KALIBRO_CONFIGURATIONS[:data][:licenses][0]
  description MezuroInformations::KALIBRO_CONFIGURATIONS[:data][:desc]
  arch        'all'

  revision MezuroInformations::KALIBRO_CONFIGURATIONS[:info][:release]

  config_files '/etc/mezuro/kalibro-configurations/database.yml', '/etc/mezuro/kalibro-configurations/secrets.yml'

  directories '/usr/share/mezuro/kalibro-configurations'

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

    generate_script(workdir("../post_install.sh"), workdir("post_install.sh"), 'kalibro-configurations', 8083)
    generate_script(workdir("../admin.sh"), builddir("admin.sh"), 'kalibro-configurations', nil)

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
    bin.install builddir('admin.sh'), 'kalibro-configurations-admin'
  end
end
