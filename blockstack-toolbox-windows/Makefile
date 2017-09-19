.PHONY: docs windows sign-windows

default: windows
	@true

clean: clean-osx clean-windows
	@true

windows: clean-windows
	./script/build-windows

clean-windows:
	rm -f dist/DockerToolbox-*.exe

docs:
	$(MAKE) -C docs docs

sign-windows:
	./script/sign-windows
