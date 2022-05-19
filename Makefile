HUGO_VERSION := 0.69.0
HUGO ?= .cache/hugo-v$(HUGO_VERSION)
THEME := minimo
THEME_SUBMODULE := themes/$(THEME)/theme.toml

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

$(THEME_SUBMODULE):
	git submodule update --init --recursive

.PHONY: develop
develop: $(HUGO) $(THEME_SUBMODULE)
	$(HUGO) server --enableGitInfo --minify --forceSyncStatic --gc

.PHONY: hugo-new
hugo-new: $(HUGO)
	$(call ndef,path)
	$(HUGO) new $(path)
