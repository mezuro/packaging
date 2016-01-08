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

  depends 'postgresql', 'postgresql-server', 'ruby', 'ruby-devel', 'gcc', 'gcc-c++', 'patch', 'zlib-devel', 'rubygem-bundler', 'sqlite-devel', 'postgresql-devel', 'redhat-rpm-config'

  post_install "post_install.sh"
end
