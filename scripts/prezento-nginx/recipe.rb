require_relative '../../mezuro_informations'

class PrezentoNginx < FPM::Cookery::Recipe
  name     MezuroInformations::PREZENTO_NGINX[:data][:name]
  version  MezuroInformations::PREZENTO_NGINX[:info][:version]
  source  "file://#{File.dirname(__FILE__)}/prezento.conf", with: :local_path

  maintainer  'Mezuro Team <mezurometrics@gmail.com>'
  description MezuroInformations::PREZENTO_NGINX[:data][:desc]
  arch        'all'

  revision MezuroInformations::PREZENTO_NGINX[:info][:release]

  config_files '/etc/nginx/default.d/prezento.conf'

  case platform
  when :centos
    then
    depends 'nginx'
  when :debian
    then
    raise NotImplementedError
  end

  def build; end

  def install
    etc('nginx/default.d').install 'prezento.conf'
  end
end
