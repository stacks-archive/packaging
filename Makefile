ROOT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

BUILD := $(ROOT_DIR)/build
DEBS_OUT := $(BUILD)/debs
DEBS_SRC := $(ROOT_DIR)/debs/

DEBS_REPO_OUT := $(BUILD)/repositories/debian

RELEASE ?= nightly

BUILD_SRC=$(BUILD)/src
BUILD_PKG=$(BUILD)/pkg

PKG_METADATA="./pkg-metadata"

GPGKEYID ?= DB858875   # Jude's package-signing key ID

.PHONY: all
all: debian-repository

$(BUILD):
	@mkdir -p "$(BUILD)"

.PHONY: repos
repos: $(BUILD)
	./fetch-repos.sh $(PKG_METADATA) "$(BUILD_SRC)" "$(RELEASE)"

.PHONY: metadata
metadata: $(BUILD) repos
	./gen-metadata.sh "$(BUILD_SRC)" "$(BUILD_PKG)"

debs: $(BUILD) repos metadata
	@mkdir -p "$(DEBS_OUT)"
	./build-packages.sh "$(BUILD_SRC)" "$(BUILD_PKG)" "$(DEBS_OUT)"

debian-repository: debs
	@mkdir -p "$(DEBS_REPO_OUT)"
	$(MAKE) -C "$(DEBS_SRC)" REPO_OUT=$(DEBS_REPO_OUT) DEBS=$(DEBS_OUT) GPGKEYID=$(GPGKEYID)

.PHONY: clean
clean: build-clean

build-clean:
	@rm -rf "$(BUILD)"
