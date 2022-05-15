HUGO_VERSION := 0.69.0
HUGO ?= .cache/hugo-v$(HUGO_VERSION)

UNAME := $(shell uname -s)
ifeq ($(UNAME),Linux)
PLATFORM := Linux
else ifeq ($(UNAME),Darwin)
PLATFORM := macOS
else
$(error "Unknown platform. Don't know which binary to fetch!")
endif

# ndef checks if a variable is defined
ndef = $(if $(value $(1)),,$(error $(1) not set))

$(HUGO):
	@mkdir -p .cache
	curl -L https://github.com/gohugoio/hugo/releases/download/v$(HUGO_VERSION)/hugo_$(HUGO_VERSION)_$(PLATFORM)-64bit.tar.gz \
		| tar xvzf - -C .cache
	mv .cache/hugo $(HUGO)

# https://stackoverflow.com/a/52407662/10667555
.PHONY: check-and-reinit-submodules
check-and-reinit-submodules:
	@if git submodule status | grep -q '^[-]|^[+]'; then \
		echo "INFO: Need to reinitialize git submodules"; \
		git submodule update --init; \
	fi

.PHONY: develop
develop: $(HUGO)
	$(HUGO) server --enableGitInfo --minify --forceSyncStatic --gc

.PHONY: hugo-new
hugo-new: $(HUGO)
	$(call ndef,path)
	$(HUGO) new $(path)
