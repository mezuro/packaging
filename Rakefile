task default: %w[centos:all debian:all]

namespace :debian do
  desc 'Build the whole Mezuro packages for Debian'
  task :all => [:container] do
    sh "docker run -t -i --volume=#{Dir.pwd}/pkgs:/root/mezuro/pkgs mezuro-debian-build"
  end

  desc 'Build the KalibroConfigurations package for Debian'
  task :kalibro_configurations => [:container] do
    sh "docker run -t -i --volume=#{Dir.pwd}/pkgs:/root/mezuro/pkgs mezuro-debian-build bash /root/mezuro/scripts/kalibro_configurations/run.sh"
  end

  desc 'Build the KalibroProcessor package for Debian'
  task :kalibro_processor => [:container] do
    sh "docker run -t -i --volume=#{Dir.pwd}/pkgs:/root/mezuro/pkgs mezuro-debian-build bash /root/mezuro/scripts/kalibro_processor/run.sh"
  end

  desc 'Build the whole Docker containerfor Debian'
  task :container => [:mk_structure] do
    sh 'docker build --rm=true --tag mezuro-debian-build -f Dockerfile-debian .'
  end
end

namespace :centos do
  desc 'Build the whole Mezuro packages for CentOS'
  task :all => [:container, :kalibro_configurations, :kalibro_processor] do
    sh "docker run -t -i --volume=#{Dir.pwd}/pkgs:/root/mezuro/pkgs mezuro-centos-build"
  end

  desc 'Build the KalibroConfigurations package for CentOS'
  task :kalibro_configurations do
    sh "docker run -t -i --volume=#{Dir.pwd}/pkgs:/root/mezuro/pkgs mezuro-centos-build bash /root/mezuro/scripts/kalibro_configurations/run.sh"
  end

  desc 'Build the KalibroProcessor package for CentOS'
  task :kalibro_processor do
    sh "docker run -t -i --volume=#{Dir.pwd}/pkgs:/root/mezuro/pkgs mezuro-centos-build bash /root/mezuro/scripts/kalibro_processor/run.sh"
  end

  desc 'Build the whole Docker containerfor CentOS'
  task :container => [:mk_structure] do
    sh 'docker build --rm=true --tag mezuro-centos-build -f Dockerfile-centos .'
  end
end

desc 'Create build dirs'
task :mk_structure do
  sh "mkdir -p pkgs/kalibro_configurations"
  sh "mkdir -p pkgs/kalibro_processor"
end

desc 'Undo mk_structure'
task :clean do
  sh 'docker build --rm=true --no-cache=true --tag mezuro-debian-build -f Dockerfile-debian .'
  sh 'docker build --rm=true --no-cache=true --tag mezuro-centos-build -f Dockerfile-centos .'
  sh "rm -rf src pkgs"
end