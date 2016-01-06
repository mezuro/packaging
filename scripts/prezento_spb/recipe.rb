require_relative '../prezento/recipe'

class PrezentoSPB < Prezento
  name     MezuroInformations::PREZENTO_SPB[:data][:name]
  version  MezuroInformations::PREZENTO_SPB[:info][:version]
  source   MezuroInformations::PREZENTO_SPB[:data][:vcs_url], :with => :git, :tag => "v#{version}.colab4"

  maintainer  'Mezuro Team <mezurometrics@gmail.com>'
  license     MezuroInformations::PREZENTO_SPB[:data][:licenses][0]
  description MezuroInformations::PREZENTO_SPB[:data][:desc]
  arch        'all'

  revision MezuroInformations::PREZENTO_SPB[:info][:release]

  case platform
  when :centos
    then
    depends 'postgresql', 'postgresql-server', 'ruby', 'ruby-devel', 'gcc', 'gcc-c++', 'patch', 'zlib-devel', 'rubygem-bundler', 'sqlite-devel', 'postgresql-devel', 'redhat-rpm-config', 'kalibro-processor', 'kalibro-configurations'
  when :debian
    then
    depends 'postgresql', 'ruby', 'bundler', 'libsqlite3-dev', 'postgresql-server-dev-9.4', 'kalibro-processor', 'kalibro-configurations'
  end

  post_install "post_install.sh"
end
