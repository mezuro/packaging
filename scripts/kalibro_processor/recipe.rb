require_relative '../generate_script'
require_relative '../../mezuro_informations'

class KalibroProcessor < FPM::Cookery::Recipe
  include GenerateScript

  name     MezuroInformations::KALIBRO_PROCESSOR[:data][:name]
  version  MezuroInformations::KALIBRO_PROCESSOR[:info][:version]
  source   MezuroInformations::KALIBRO_PROCESSOR[:data][:vcs_url], :with => :git, :tag => "v#{version}"

  maintainer  'Mezuro Team <mezurometrics@gmail.com>'
  license     MezuroInformations::KALIBRO_PROCESSOR[:data][:licenses][0]
  description MezuroInformations::KALIBRO_PROCESSOR[:data][:desc]
  arch        'all'

  revision MezuroInformations::KALIBRO_PROCESSOR[:info][:release]

  config_files '/etc/mezuro/kalibro-processor/database.yml', '/etc/mezuro/kalibro-processor/secrets.yml', '/etc/mezuro/kalibro-processor/repositories.yml'

  case platform
  when :centos
    then
    depends 'postgresql', 'postgresql-server', 'ruby', 'ruby-devel', 'gcc', 'gcc-c++', 'patch', 'zlib-devel', 'rubygem-bundler', 'sqlite-devel', 'postgresql-devel', 'redhat-rpm-config', 'git'
  when :debian
    then
    depends 'postgresql', 'ruby', 'bundler', 'libsqlite3-dev', 'postgresql-server-dev-9.4', 'git'
  end

  post_install "post_install.sh"

  def build
    inline_replace 'config/database.yml.sample' do |s|
      s.gsub! /^(\s*)username:(.*)/, ''
      s.gsub! /^(\s*)password:(.*)/, ''
    end

    generate_script(workdir("../post_install.sh"), workdir("post_install.sh"), 'kalibro-processor', 8082)
    generate_script(workdir("../admin.sh"), builddir("admin.sh"), 'kalibro-processor', nil)

    safesystem("bundle package --all --all-platforms")
  end

  def install
    etc('mezuro/kalibro-processor').install 'config/database.yml.sample', 'database.yml'
    ln_s '/etc/mezuro/kalibro-processor/database.yml', 'config/database.yml'
    etc('mezuro/kalibro-processor').install 'config/secrets.yml', 'secrets.yml'
    rm 'config/secrets.yml'
    ln_s '/etc/mezuro/kalibro-processor/secrets.yml', 'config/secrets.yml'
    etc('mezuro/kalibro-processor').install 'config/repositories.yml.sample', 'repositories.yml'
    ln_s '/etc/mezuro/kalibro-processor/repositories.yml', 'config/repositories.yml'
    share('mezuro/kalibro-processor').install Dir['*']
    share('mezuro/kalibro-processor').install %w(.bundle .env)
    bin.install builddir('admin.sh'), 'kalibro-processor-admin'
  end
end
