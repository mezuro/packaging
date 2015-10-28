class KalibroConfigurations < FPM::Cookery::Recipe

  name     'kalibro-configurations'
  version  'v1.2.0'
  source   'https://github.com/mezuro/kalibro_configurations.git', :with => :git, :tag => version

  maintainer  'Mezro Team <mezurometrics@gmail.com>'
  license     'AGPLv3'
  description 'Web service for managing code analysis configurations'
  arch        'all'

  revision '1'

  config_files '/etc/mezuro/kalibro-configurations/database.yml'

  depends 'postgresql'

  def build
    gemhome = Pathname.pwd.join('.gemhome').to_s

    ENV['GEM_HOME'] = gemhome

    safesystem('gem install bundler --no-ri --no-rdoc')

    safesystem("#{gemhome}/bin/bundle install --deployment --without development:test")
  end

  def install
    etc('mezuro/kalibro-configurations').install_p 'config/database.yml.postgresql_sample', 'database.yml'
    share('kalibro-configurations').install Dir['*']
    share('kalibro-configurations').install %w(.bundle .gitignore .gemhome)
  end
end
