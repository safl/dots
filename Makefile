REPO_PATH   := $(HOME)/secrets
BUNDLE_PATH := $(REPO_PATH).bundle
AGE_PATH    := $(BUNDLE_PATH).age

.PHONY: info help clean restore backup setup

define help-help
# Print the description of every target in the Makefile
endef
.PHONY: help
help:
	@./scripts/usage.py --repos . --colorize

info: ## Show current config
	@echo "REPO_PATH   = $(REPO_PATH)"
	@echo "AGE_PATH    = $(AGE_PATH)"
	@echo "BUNDLE_PATH = $(BUNDLE_PATH)"

define clean-help
# Remove local (restoreed) bundle if present
endef
clean:
	@rm -f "$(BUNDLE_PATH)"

define restore-help
# Decrypts the git-bundle, using age, and places it in $HOME/secrets
endef
restore: info
	./scripts/decrypt.sh $(AGE_PATH) $(BUNDLE_PATH) $(REPO_PATH)

define backup-help
# Create an encrypted git-bundle, using age, of the repos in $HOME/secrets
endef
backup: info
	./scripts/encrypt.sh $(AGE_PATH) $(BUNDLE_PATH) $(REPO_PATH)

define setup-help
# Cleans, restores and runs all tasks in tasks/
endef
setup: info clean restore
	./setup.sh
