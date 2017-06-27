ROOT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

BUILD := $(ROOT_DIR)/build
DEBS_OUT := $(BUILD)/debs
DEBS_SRC := $(ROOT_DIR)/debs/

DEBS_REPO_OUT := $(BUILD)/repositories/debian

RELEASE ?= stable
DEBIAN_RELEASE ?= xenial 

BUILD_SRC=$(BUILD)/src
BUILD_PKG=$(BUILD)/pkg

DEPLOY_DEBS_SCRIPT=./deploy-debs.sh
DEPLOY_PYPI_SCRIPT=./deploy-pypi.sh

BREW_SCRIPT=./build-brew.sh
BREW_IN=./brew/blockstack.rb.in

PKG_METADATA="./pkg-metadata"

# Jude's package-signing key ID
GPGKEYID ?= DB858875

# must be populated locally; not in git
PYPI_SECRETS ?= $(ROOT_DIR)/pypi-secrets/

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

browser-deb:
	@mkdir -p "$(DEBS_OUT)"
	./make-browser.sh "$(BUILD_SRC)" "$(DEBS_OUT)"

debs: $(BUILD) repos metadata browser-deb
	@mkdir -p "$(DEBS_OUT)"
	./build-packages.sh "$(BUILD_SRC)" "$(BUILD_PKG)" "$(DEBS_OUT)"

debian-repository: debs
	@mkdir -p "$(DEBS_REPO_OUT)"
	$(MAKE) -C "$(DEBS_SRC)" REPO_OUT=$(DEBS_REPO_OUT) DEBS=$(DEBS_OUT) GPGKEYID=$(GPGKEYID) DEBIAN_RELEASE=$(DEBIAN_RELEASE)

.PHONY: deploy deploy-debs deploy-pypi

deploy: deploy-debs 

deploy-debs:
	$(SHELL) -x $(DEPLOY_DEBS_SCRIPT) "$(DEBS_REPO_OUT)"

deploy-pypi: $(BUILD) repos metadata
	$(SHELL) -x $(DEPLOY_PYPI_SCRIPT) "$(BUILD_SRC)" "$(BUILD_PKG)" "$(PYPI_SECRETS)"

.PHONY: brew
brew:
	@mkdir -p "$(BUILD)/brew"
	$(SHELL) -x $(BREW_SCRIPT) "$(BREW_IN)" "$(BUILD)/brew/blockstack.rb"

.PHONY: clean
clean: build-clean

build-clean:
	@rm -rf "$(BUILD)"
