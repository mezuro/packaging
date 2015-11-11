task default: %w[centos debian]

desc 'Build the whole Mezuro packages for Debian'
task :debian => [:mk_structure] do
  sh 'docker build --rm=true --tag mezuro-debian-build -f Dockerfile-debian .'
  sh "docker run -t -i --volume=#{Dir.pwd}/pkgs:/root/mezuro/pkgs mezuro-debian-build"
end

desc 'Build the whole Mezuro packages for CentOS'
task :centos => [:mk_structure] do
  sh 'docker build --rm=true --tag mezuro-centos-build -f Dockerfile-centos .'
  sh "docker run -t -i --volume=#{Dir.pwd}/pkgs:/root/mezuro/pkgs mezuro-centos-build"
end

desc 'Create build dirs and fetch source files'
task :mk_structure do
  sh "mkdir -p pkgs/kalibro_configurations"
end

desc 'Undo mk_structure'
task :clean do
  sh 'docker build --rm=true --no-cache=true --tag mezuro-debian-build -f Dockerfile-debian .'
  sh 'docker build --rm=true --no-cache=true --tag mezuro-centos-build -f Dockerfile-centos .'
  sh "rm -rf src pkgs"
end