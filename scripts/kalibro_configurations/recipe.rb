require_relative '../generate_post_install'

class KalibroConfigurations < FPM::Cookery::Recipe
  include GeneratePostInstall

  name     'kalibro-configurations'
  version  '1.2.1'
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
  end

  def install
    etc('mezuro/kalibro-configurations').install 'config/database.yml.postgresql_sample', 'database.yml'
    ln_s '/etc/mezuro/kalibro-configurations/database.yml', 'config/database.yml'
    share('mezuro/kalibro-configurations').install Dir['*']
    share('mezuro/kalibro-configurations').install %w(.bundle)
  end
end
