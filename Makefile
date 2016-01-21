DEBS=debs/
REPO=../

.PHONY: all
all: debs

debs: debs-clean
	./build-packages.sh "$(REPO)" "$(DEBS)"
	$(MAKE) -C "$(DEBS)"

.PHONY: clean
clean: debs-clean

debs-clean:
	$(MAKE) -C "$(DEBS)" clean
