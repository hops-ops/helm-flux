SHELL := /bin/bash

PACKAGE ?= helm-flux
XRD_DIR := apis/fluxes
COMPOSITION := $(XRD_DIR)/composition.yaml
DEFINITION := $(XRD_DIR)/definition.yaml
RENDER_TESTS := $(wildcard tests/test-*)
E2E_TESTS := $(wildcard tests/e2etest-*)

clean:
	rm -rf _output .up

build:
	up project build

EXAMPLES := examples/fluxes/minimal.yaml:: examples/fluxes/standard.yaml::

render\:all:
	@for entry in $(EXAMPLES); do example=$${entry%%::*}; echo "=== Rendering $$example ==="; up composition render --xrd=$(DEFINITION) $(COMPOSITION) $$example; done

validate\:all:
	@for entry in $(EXAMPLES); do example=$${entry%%::*}; echo "=== Validating $$example ==="; up composition render --xrd=$(DEFINITION) $(COMPOSITION) $$example --include-full-xr --quiet | crossplane beta validate $(XRD_DIR) --error-on-missing-schemas -; done

.PHONY: render validate
render: ; @$(MAKE) 'render:all'
validate: ; @$(MAKE) 'validate:all'

test:
	up test run $(RENDER_TESTS)

e2e:
	up test run $(E2E_TESTS) --e2e

publish:
	@if [ -z "$(tag)" ]; then echo "Error: tag not set"; exit 1; fi
	up project build --push --tag $(tag)
