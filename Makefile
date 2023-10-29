# Disable all the default make stuff
MAKEFLAGS += --no-builtin-rules
.SUFFIXES:

## Display help menu
.PHONY: help
help:
	@echo Documented Make targets:
	@perl -e 'undef $$/; while (<>) { while ($$_ =~ /## (.*?)(?:\n# .*)*\n.PHONY:\s+(\S+).*/mg) { printf "\033[36m%-30s\033[0m %s\n", $$2, $$1 } }' $(MAKEFILE_LIST) | sort

# ------------------------------------------------------------------------------
# NON-PHONY TARGETS
# ------------------------------------------------------------------------------

spego:
	git clone git@github.com:kevinswiber/spego.git

# ------------------------------------------------------------------------------
# PHONY TARGETS
# ------------------------------------------------------------------------------

.PHONY: check-api
check-api: spego
	cat specs/example-api.yaml | opa eval --format pretty --bundle spego/src -I 'data.openapi.main.results'
