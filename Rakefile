require "rspec/core/rake_task"

require_relative 'mezuro_informations.rb'
require_relative 'scripts/bintray/bintray.rb'
require_relative 'helpers'

include Helpers

task default: %w[centos:all debian:all]

RSpec::Core::RakeTask.new(:spec)

directory 'pkgs/kalibro-configurations'
directory 'pkgs/kalibro-processor'
directory 'pkgs/prezento'
directory 'pkgs/prezento-nginx'

namespace :debian do
  desc 'Build the whole Mezuro packages for Debian'
  task :all => [:prezento, :prezento_nginx]

  kalibro_configurations_deb = deb_path('kalibro-configurations', MezuroInformations::KALIBRO_CONFIGURATIONS[:info])
  kalibro_processor_deb = deb_path('kalibro-processor', MezuroInformations::KALIBRO_PROCESSOR[:info])
  prezento_deb = deb_path('prezento', MezuroInformations::PREZENTO[:info])
  prezento_nginx_deb = deb_path('prezento-nginx', MezuroInformations::PREZENTO_NGINX[:info])

  desc 'Build the KalibroConfigurations package for Debian'
  task :kalibro_configurations => [:container, kalibro_configurations_deb]

  file kalibro_configurations_deb => ['scripts/kalibro_configurations/recipe.rb',
                                      'pkgs/kalibro-configurations'] do
    sh "docker run -t -i --volume=#{Dir.pwd}/pkgs:/root/mezuro/pkgs mezuro-debian-build bash /root/mezuro/scripts/kalibro_configurations/run.sh"
  end

  desc 'Build the KalibroProcessor package for Debian'
  task :kalibro_processor => [:container, kalibro_processor_deb]

  file kalibro_processor_deb => ['scripts/kalibro_processor/recipe.rb',
                                 'pkgs/kalibro-processor'] do
    sh "docker run -t -i --volume=#{Dir.pwd}/pkgs:/root/mezuro/pkgs mezuro-debian-build bash /root/mezuro/scripts/kalibro_processor/run.sh"
  end

  desc 'Build the Prezento package for Debian'
  task :prezento => [:container, prezento_deb]

  file prezento_deb => ['scripts/prezento/recipe.rb',
                        kalibro_configurations_deb,
                        kalibro_processor_deb,
                        'pkgs/prezento'] do
    sh "docker run -t -i --volume=#{Dir.pwd}/pkgs:/root/mezuro/pkgs mezuro-debian-build bash /root/mezuro/scripts/prezento/run.sh /root/mezuro/#{kalibro_configurations_deb} /root/mezuro/#{kalibro_processor_deb}"
  end

  desc 'Build the Prezento NGINX proxy configuration package for CentOS'
  task :prezento_nginx => [:container, prezento_nginx_deb]

  file prezento_nginx_deb => ['scripts/prezento-nginx/recipe.rb',
                              'pkgs/prezento-nginx'] do
    sh "docker run -t -i --volume=#{Dir.pwd}/pkgs:/root/mezuro/pkgs mezuro-debian-build bash /root/mezuro/scripts/prezento-nginx/run.sh"
  end


  desc 'Build the whole Docker container for Debian'
  task :container => ['Dockerfile-debian'] do
    sh 'docker build --rm=true --tag mezuro-debian-build -f Dockerfile-debian .'
  end

  desc 'Publishes a package on BinTray'
  task :publish, [:package] do |t, args|
    publish_package('deb', args[:package])
  end
end

namespace :centos do
  desc 'Build the whole Mezuro packages for CentOS'
  task :all => [:prezento, :prezento_nginx] do
  end

  kalibro_configurations_rpm = rpm_path('kalibro-configurations', MezuroInformations::KALIBRO_CONFIGURATIONS[:info])
  kalibro_processor_rpm = rpm_path('kalibro-processor', MezuroInformations::KALIBRO_PROCESSOR[:info])
  prezento_rpm = rpm_path('prezento', MezuroInformations::PREZENTO[:info])
  prezento_nginx_rpm = rpm_path('prezento-nginx', MezuroInformations::PREZENTO_NGINX[:info])

  desc 'Build the KalibroConfigurations package for CentOS'
  task :kalibro_configurations => [:container, kalibro_configurations_rpm]

  file kalibro_configurations_rpm => ['scripts/kalibro_configurations/recipe.rb',
                                      'pkgs/kalibro-configurations'] do
    sh "docker run -t -i --volume=#{Dir.pwd}/pkgs:/root/mezuro/pkgs mezuro-centos-build bash /root/mezuro/scripts/kalibro_configurations/run.sh"
  end

  desc 'Build the KalibroProcessor package for CentOS'
  task :kalibro_processor => [:container, kalibro_processor_rpm]

  file kalibro_processor_rpm => ['scripts/kalibro_processor/recipe.rb',
                                 'pkgs/kalibro-processor'] do
    sh "docker run -t -i --volume=#{Dir.pwd}/pkgs:/root/mezuro/pkgs mezuro-centos-build bash /root/mezuro/scripts/kalibro_processor/run.sh"
  end

  desc 'Build the Prezento package for CentOS'
  task :prezento => [:container, prezento_rpm]

  file prezento_rpm => ['scripts/prezento/recipe.rb',
                        kalibro_configurations_rpm,
                        kalibro_processor_rpm,
                        'pkgs/prezento'] do
    sh "docker run -t -i --volume=#{Dir.pwd}/pkgs:/root/mezuro/pkgs mezuro-centos-build bash /root/mezuro/scripts/prezento/run.sh /root/mezuro/#{kalibro_configurations_rpm} /root/mezuro/#{kalibro_processor_rpm}"
  end

  desc 'Build the Prezento NGINX proxy configuration package for CentOS'
  task :prezento_nginx => [:container, prezento_nginx_rpm]

  file prezento_nginx_rpm => ['scripts/prezento-nginx/recipe.rb',
                              'pkgs/prezento-nginx'] do
    sh "docker run -t -i --volume=#{Dir.pwd}/pkgs:/root/mezuro/pkgs mezuro-centos-build bash /root/mezuro/scripts/prezento-nginx/run.sh"
  end

  desc 'Build the whole Docker containerfor CentOS'
  task :container => ['Dockerfile-centos'] do
    sh 'docker build --rm=true --tag mezuro-centos-build -f Dockerfile-centos .'
  end

  desc 'Publishes a package on BinTray'
  task :publish, [:package] do |t, args|
    publish_package('rpm', args[:package])
  end
end

desc 'Undo mk_structure'
task :clean do
  sh 'docker build --rm=true --no-cache=true --tag mezuro-debian-build -f Dockerfile-debian .'
  sh 'docker build --rm=true --no-cache=true --tag mezuro-centos-build -f Dockerfile-centos .'
  sh "rm -rf src pkgs"
end
