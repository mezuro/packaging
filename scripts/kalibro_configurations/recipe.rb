require_relative '../generate_post_install'

class KalibroConfigurations < FPM::Cookery::Recipe
  include GeneratePostInstall

  name     'kalibro-configurations'
  version  '1.2.2'
  source   'https://github.com/mezuro/kalibro_configurations.git', :with => :git, :tag => "v#{version}"

  maintainer  'Mezuro Team <mezurometrics@gmail.com>'
  license     'AGPLv3'
  description 'Web service for managing code analysis configurations'
  arch        'all'

  revision '1'

  config_files '/etc/mezuro/kalibro-configurations/database.yml'

  depends 'postgresql', 'ruby', 'bundler'

  post_install "post_install.rb"

  def build
    inline_replace 'config/database.yml.postgresql_sample' do |s|
      s.gsub! /^(\s*)username:(.*)/, ''
      s.gsub! /^(\s*)password:(.*)/, ''
    end

    generate_post_install("#{File.dirname(__FILE__)}/post_install.rb", 'kalibro-configurations')

    safesystem("bundle install --deployment --without development:test --path vendor/bundle")
    safesystem("bundle exec foreman export systemd -a #{name} -u #{name.gsub('-', '_')} .")
  end

  def install
    etc('mezuro/kalibro-configurations').install 'config/database.yml.postgresql_sample', 'database.yml'
    ln_s '/etc/mezuro/kalibro-configurations/database.yml', 'config/database.yml'
    share('mezuro/kalibro-configurations').install Dir['*']
    share('mezuro/kalibro-configurations').install %w(.bundle)
    lib('systemd/system').install 'kalibro-configurations.target', 'kalibro-configurations.target'
    lib('systemd/system').install 'kalibro-configurations-web.target', 'kalibro-configurations-web.target'
    lib('systemd/system').install 'kalibro-configurations-web-1.service', 'kalibro-configurations-web-1.service'
  end
end
