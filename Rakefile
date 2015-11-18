require_relative 'versions.rb'

task default: %w[centos:all debian:all]

def deb_path(pkg, info)
  "pkgs/#{pkg}/#{pkg}_#{info[:version]}-#{info[:release]}_all.deb"
end

def rpm_path(pkg, info)
  "pkgs/#{pkg}/#{pkg}-#{info[:version]}-#{info[:release]}.noarch.rpm"
end

directory 'pkgs/kalibro-configurations'
directory 'pkgs/kalibro-processor'
directory 'pkgs/prezento'

namespace :debian do
  desc 'Build the whole Mezuro packages for Debian'
  task :all => [:prezento]

  kalibro_configurations_deb = deb_path('kalibro-configurations', MezuroVersions::KALIBRO_CONFIGURATIONS)
  kalibro_processor_deb = deb_path('kalibro-processor', MezuroVersions::KALIBRO_PROCESSOR)
  prezento_deb = deb_path('prezento', MezuroVersions::PREZENTO)

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

  desc 'Build the whole Docker container for Debian'
  task :container => ['Dockerfile-debian'] do
    sh 'docker build --rm=true --tag mezuro-debian-build -f Dockerfile-debian .'
  end
end

namespace :centos do
  desc 'Build the whole Mezuro packages for CentOS'
  task :all => [:kalibro_configurations, :kalibro_processor, :prezento] do
  end

  desc 'Build the KalibroConfigurations package for CentOS'
  task :kalibro_configurations => [:container] do
    sh "docker run -t -i --volume=#{Dir.pwd}/pkgs:/root/mezuro/pkgs mezuro-centos-build bash /root/mezuro/scripts/kalibro_configurations/run.sh"
  end

  desc 'Build the KalibroProcessor package for CentOS'
  task :kalibro_processor => [:container] do
    sh "docker run -t -i --volume=#{Dir.pwd}/pkgs:/root/mezuro/pkgs mezuro-centos-build bash /root/mezuro/scripts/kalibro_processor/run.sh"
  end

  desc 'Build the Prezento package for CentOS'
  task :prezento => [:container] do
    sh "docker run -t -i --volume=#{Dir.pwd}/pkgs:/root/mezuro/pkgs mezuro-centos-build bash /root/mezuro/scripts/prezento/run.sh"
  end

  desc 'Build the whole Docker containerfor CentOS'
  task :container => [:mk_structure] do
    sh 'docker build --rm=true --tag mezuro-centos-build -f Dockerfile-centos .'
  end
end

desc 'Undo mk_structure'
task :clean do
  sh 'docker build --rm=true --no-cache=true --tag mezuro-debian-build -f Dockerfile-debian .'
  sh 'docker build --rm=true --no-cache=true --tag mezuro-centos-build -f Dockerfile-centos .'
  sh "rm -rf src pkgs"
end
