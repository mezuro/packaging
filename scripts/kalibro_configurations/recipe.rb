class KalibroConfigurations < FPM::Cookery::Recipe

  name     'kalibro-configurations'
  version  '1.2.0'
  source   'https://github.com/mezuro/kalibro_configurations.git', :with => :git, :tag => "v#{version}"

  maintainer  'Mezuro Team <mezurometrics@gmail.com>'
  license     'AGPLv3'
  description 'Web service for managing code analysis configurations'
  arch        'all'

  revision '1'

  config_files '/etc/mezuro/kalibro-configurations/database.yml'

  build_depends 'ruby', 'bundler'
  depends 'postgresql', 'ruby', 'bundler'

  def build
    safesystem("bundle install --deployment --without development:test --path vendor/bundle")
  end

  def install
    etc('mezuro/kalibro-configurations').install_p 'config/database.yml.postgresql_sample', 'database.yml'
    share('mezuro/kalibro-configurations').install Dir['*']
    share('mezuro/kalibro-configurations').install %w(.bundle)
  end
end
