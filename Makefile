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
	cat specs/example-api.yaml | opa eval --format pretty --bundle spego/src -d spego.conf.yaml -I 'data.openapi.main.problems' | tee /dev/stderr | jq -e '[.[] | select(.severity != "warn") ] | length == 0'

.PHONY: gen
gen:
	cd src/common; \
	curl -O -L https://astromechza.github.io/api-first-playground/common-api.yaml; \
	go run github.com/deepmap/oapi-codegen/cmd/oapi-codegen@v1.16.2 --config=common-api-codegen.cfg.yaml common-api.yaml
	cd src; \
	go run github.com/deepmap/oapi-codegen/cmd/oapi-codegen@v1.16.2 --config=example-api-codegen.cfg.yaml ../specs/example-api.yaml