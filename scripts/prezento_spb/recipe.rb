require_relative '../prezento/recipe'

class PrezentoSPB < Prezento
  name     MezuroInformations::PREZENTO_SPB[:data][:name]
  version  MezuroInformations::PREZENTO_SPB[:info][:version]
  source   MezuroInformations::PREZENTO_SPB[:data][:vcs_url], :with => :git, :tag => "v#{version}.colab"

  maintainer  'Mezuro Team <mezurometrics@gmail.com>'
  license     MezuroInformations::PREZENTO_SPB[:data][:licenses][0]
  description MezuroInformations::PREZENTO_SPB[:data][:desc]
  arch        'all'

  revision MezuroInformations::PREZENTO_SPB[:info][:release]
end