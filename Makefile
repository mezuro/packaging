.PHONY: main ubuntu mk_structure clean

CONFIGURATIONS_TAG=v1.2.0

main: ubuntu

ubuntu: mk_structure
	docker build --rm=true --tag mezuro-ubuntu-build -f Dockerfile-ubuntu .
	docker run -t -i --volume=$(PWD)/pkgs:/root/mezuro/pkgs mezuro-ubuntu-build

mk_structure:
	mkdir -p src
	git clone https://github.com/mezuro/kalibro_configurations.git -b $(CONFIGURATIONS_TAG) src/kalibro_configurations

	mkdir -p pkgs

clean:
	rm -rf src pkgs