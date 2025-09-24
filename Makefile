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
# Decrypt the git-bundle, using age, and place the repos in $HOME/secrets
endef
decrypt:
	./scripts/decrypt.sh $(AGE_PATH) $(BUNDLE_PATH) $(REPO_PATH)

define encrypt-help
# Create an encrypted git-bundle, using age, of the repos in $HOME/secrets
endef
encrypt:
	./scripts/encrypt.sh $(AGE_PATH) $(BUNDLE_PATH) $(REPO_PATH)

define setup-help
# Cleans, decrypts and runs all tasks in tasks/
endef
setup: clean decrypt
	./setup.sh
