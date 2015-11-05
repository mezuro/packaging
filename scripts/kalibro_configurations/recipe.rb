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

  depends 'postgresql', 'ruby', 'bundler'

  def build
    inline_replace 'config/database.yml.postgresql_sample' do |s|
      s.gsub! /^(\s*)username:(.*)/, '  template: :template0'
      s.gsub! /^(\s*)password:(.*)/, ''
    end

    safesystem("bundle install --deployment --without development:test --path vendor/bundle")
    etc('mezuro/kalibro-configurations').install 'config/database.yml.postgresql_sample', 'database.yml'
  end

  def install
    safesystem('sudo -u postgres psql -c "create role root with createdb login"')

    ln_s '/etc/mezuro/kalibro-configurations/database.yml', 'config/database.yml'
    share('mezuro/kalibro-configurations').install Dir['*']
    share('mezuro/kalibro-configurations').install %w(.bundle)
    system('ls /etc/mezuro/kalibro-configurations')
    safesystem('bundle exec rake db:setup --trace')
  end
end
