REPO_OUT ?= /none
DEBS ?= /none
DISTRIBUTION_IN := conf/distributions.in
GPGKEYID ?= none

DISTRIBUTION_OUT := $(REPO_OUT)/conf/distributions
PUBKEY_OUT := $(REPO_OUT)/repo-key.pub

.PHONY: all
all: $(DISTRIBUTION_OUT) $(PUBKEY_OUT) repository

$(PUBKEY_OUT):
	@gpg --export --armor $(GPGKEYID) > "$@"

$(DISTRIBUTION_OUT): $(DISTRIBUTION_IN)
	@mkdir -p "$(shell dirname "$@")"
	cat "$<" | sed 's~@GPGKEYID@~$(GPGKEYID)~g' > "$@"

repository: $(DISTRIBUTION_OUT)
	@rm -rf $(REPO_OUT)/{db,dists,pool}
	@reprepro -Vb $(REPO_OUT) includedeb jessie $(DEBS)/*.deb

.PHONY: clean
clean:
	@rm -f $(DISTRIBUTION_OUT)

