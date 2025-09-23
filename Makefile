BUNDLE_PATH := $(HOME)/secrets.bundle
AGE_PATH    := $(BUNDLE_PATH).age
REPO_PATH   := $(HOME)/git/secrets

.PHONY: info help clean decrypt encrypt setup

define help-help
# Print the description of every target in the Makefile
endef
.PHONY: help
help:
	@./scripts/usage.py --repos . --colorize

info: ## Show current config
	@echo "BUNDLE_PATH = $(BUNDLE_PATH)"
	@echo "AGE_PATH    = $(AGE_PATH)"
	@echo "REPO_PATH   = $(REPO_PATH)"

define clean-help
# Remove local (decrypted) bundle if present
endef
clean: ## 
	@rm -f "$(BUNDLE_PATH)"

define decrypt-help
# Decrypt bundle and clone repo
endef
decrypt:
	@if [ ! -e "$(AGE_PATH)" ]; then \
		echo "Error: Encrypted bundle '$(AGE_PATH)' does not exist. Nothing to decrypt."; \
		exit 1; \
	fi
	@if [ -e "$(REPO_PATH)" ]; then \
		echo "Error: Repo '$(REPO_PATH)' already exists. Remove it first."; \
		exit 1; \
	fi
	@echo "Decrypting $(AGE_PATH) -> $(BUNDLE_PATH)..."
	age -d -o "$(BUNDLE_PATH)" "$(AGE_PATH)"
	@echo "Cloning bundle into $(REPO_PATH)..."
	git clone "$(BUNDLE_PATH)" "$(REPO_PATH)"
	rm -f "$(BUNDLE_PATH)"
	cd "$(REPO_PATH)" && git fsck --no-progress

define encrypt-help
# Bundle repo and encrypt with age (passphrase)
endef
encrypt:
	@if [ ! -d "$(REPO_PATH)" ]; then \
		echo "Error: Repo '$(REPO_PATH)' does not exist; nothing to encrypt."; \
		exit 1; \
	fi
	@if [ -e "$(AGE_PATH)" ]; then \
		echo "Error: Encrypted bundle '$(AGE_PATH)' already exists. Remove it first."; \
		exit 1; \
	fi
	cd "$(REPO_PATH)" && git bundle create "$(BUNDLE_PATH)" --all
	cd "$(HOME)" && age -e -p -o "$(AGE_PATH)" "$(BUNDLE_PATH)"
	rm -f "$(BUNDLE_PATH)"

define setup-help
# Cleans, decrypts and runs all tasks in tasks/
endef
setup: clean decrypt
	./setup.sh
