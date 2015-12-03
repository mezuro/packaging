require_relative 'mezuro_informations.rb'
require_relative 'scripts/bintray/bintray.rb'

task default: %w[centos:all debian:all]

def deb_path(pkg, info)
  "pkgs/#{pkg}/#{pkg}_#{info[:version]}-#{info[:release]}_all.deb"
end

def rpm_path(pkg, info)
  "pkgs/#{pkg}/#{pkg}-#{info[:version]}-#{info[:release]}.noarch.rpm"
end

def publish_package(type, package)
  puts ">> Starting to publish #{package} package on BinTray"
  underscored_package = package.gsub('-', '_')
  data = Kernel.const_get("MezuroInformations::#{underscored_package.upcase}")[:data]
  info = Kernel.const_get("MezuroInformations::#{underscored_package.upcase}")[:info]
  version = "#{info[:version]}-#{info[:release]}"
  path = send("#{type}_path", package, info)

  puts ">> Creating package"
  PackageManager.create(type, data)

  puts ">> Creating version #{version}"
  VersionManager.create(type, package, { name: version, desc: data[:description] })

  puts ">> Uploading package on #{path}"
  if type == 'deb'
    ContentManager.debian_upload(type, package, version, "#{package}/#{package}-#{version}",
    {distros: 'Jessie', components: 'main', archs: 'all'}, path)
  else
    ContentManager.upload(type, package, version, "#{package}/#{package}-#{version}", path)
  end

  puts ">> Publishing"
  ContentManager.publish(type, package, version)
end

directory 'pkgs/kalibro-configurations'
directory 'pkgs/kalibro-processor'
directory 'pkgs/prezento'

namespace :debian do
  desc 'Build the whole Mezuro packages for Debian'
  task :all => [:prezento]

  kalibro_configurations_deb = deb_path('kalibro-configurations', MezuroInformations::KALIBRO_CONFIGURATIONS)
  kalibro_processor_deb = deb_path('kalibro-processor', MezuroInformations::KALIBRO_PROCESSOR)
  prezento_deb = deb_path('prezento', MezuroInformations::PREZENTO)

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

  desc 'Publishes a package on BinTray'
  task :publish, [:package] do |t, args|
    publish_package('deb', args[:package])
  end
end

namespace :centos do
  desc 'Build the whole Mezuro packages for CentOS'
  task :all => :prezento do
  end

  kalibro_configurations_rpm = rpm_path('kalibro-configurations', MezuroInformations::KALIBRO_CONFIGURATIONS)
  kalibro_processor_rpm = rpm_path('kalibro-processor', MezuroInformations::KALIBRO_PROCESSOR)
  prezento_rpm = rpm_path('prezento', MezuroInformations::PREZENTO)

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
