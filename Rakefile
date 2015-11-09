task default: %w[ubuntu]

desc 'Build the whole Mezuro packages for Ubuntu'
task :ubuntu => [:mk_structure] do
  sh 'docker build --rm=true --tag mezuro-ubuntu-build -f Dockerfile-ubuntu .'
  sh "docker run -t -i --volume=#{Dir.pwd}/pkgs:/root/mezuro/pkgs mezuro-ubuntu-build"
end

desc 'Create build dirs and fetch source files'
task :mk_structure do
  sh "mkdir -p pkgs/kalibro_configurations"
end

desc 'Undo mk_structure'
task :clean do
  sh 'docker build --rm=true --no-cache=true --tag mezuro-ubuntu-build -f Dockerfile-ubuntu .'
  sh "rm -rf src pkgs"
end