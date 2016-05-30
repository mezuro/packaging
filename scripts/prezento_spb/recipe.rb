require_relative '../prezento/recipe'

# The inheritance only works for methods. So the metadata need to be redefined
class PrezentoSPB < Prezento
  name     MezuroInformations::PREZENTO_SPB[:data][:name]
  version  MezuroInformations::PREZENTO_SPB[:info][:version]
  source   MezuroInformations::PREZENTO_SPB[:data][:vcs_url], :with => :git, :tag => "v#{version}.colab#{MezuroInformations::PREZENTO_SPB_EXTRA_RELEASE}"

  maintainer  'Mezuro Team <mezurometrics@gmail.com>'
  license     MezuroInformations::PREZENTO_SPB[:data][:licenses][0]
  description MezuroInformations::PREZENTO_SPB[:data][:desc]
  arch        'all'

  revision MezuroInformations::PREZENTO_SPB[:info][:release]

  depends 'postgresql', 'postgresql-server', 'ruby', 'ruby-devel', 'gcc', 'gcc-c++', 'patch', 'zlib-devel', 'rubygem-bundler', 'sqlite-devel', 'postgresql-devel', 'redhat-rpm-config', 'libxml2-devel', 'libxslt-devel'

  directories '/usr/share/mezuro/prezento'

  post_install "post_install.sh"
  post_uninstall 'post_uninstall.sh'
end
