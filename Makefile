.ONESHELL:
.DEFAULT_GOAL := help
SHELL := /bin/bash

#virtual environment. If 0 issue warning
#Not activated:0
#activated: 1
ifeq ($(VIRTUAL_ENV),)
$(warning virtualenv not activated)
is_venv =
else
is_venv = 1
VENV_BIN := $(VIRTUAL_ENV)/bin
VENV_BIN_PYTHON := python3
PY_X_Y := $(shell $(VENV_BIN_PYTHON) -c 'import platform; t_ver = platform.python_version_tuple(); print(".".join(t_ver[:2]));')
endif

##@ Helpers

# https://www.thapaliya.com/en/writings/well-documented-makefiles/
.PHONY: help
help:					## (Default) Display this help -- Always up to date
	@awk -F ':.*##' '/^[^: ]+:.*##/{printf "  \033[1m%-20s\033[m %s\n",$$1,$$2} /^##@/{printf "\n%s\n",substr($$0,5)}' $(MAKEFILE_LIST)

##@ GNU Make standard targets

.PHONY: build
build:  ## github markdown to html
	@which pandoc &>/dev/null
	if [[ "$?" -eq 0 ]]; then
	pandoc --from=gfm --to=html5 --output=README.html README.md
	fi

##@ Context specific

.PHONY: render
render:					## run cogapp
ifeq ($(is_venv),1)
	@python -m cogapp -rP README.md
endif

.PHONY: quick-view
quick-view:				## view html
	@xdg-open README.html

.PHONY: view
view: render build quick-view	## build and view html
