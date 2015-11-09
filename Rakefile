task default: %w[debian]

desc 'Build the whole Mezuro packages for Ubuntu'
task :debian => [:mk_structure] do
  sh 'docker build --rm=true --tag mezuro-debian-build -f Dockerfile-debian .'
  sh "docker run -t -i --volume=#{Dir.pwd}/pkgs:/root/mezuro/pkgs mezuro-debian-build"
end

desc 'Create build dirs and fetch source files'
task :mk_structure do
  sh "mkdir -p pkgs/kalibro_configurations"
end

desc 'Undo mk_structure'
task :clean do
  sh 'docker build --rm=true --no-cache=true --tag mezuro-debian-build -f Dockerfile-debian .'
  sh "rm -rf src pkgs"
end