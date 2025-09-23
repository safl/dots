BUNDLE_PATH := $(HOME)/secrets.bundle
AGE_PATH    := $(BUNDLE_PATH).age
REPO_PATH   := $(HOME)/git/secrets
SSH_DIR     := $(HOME)/.ssh

.DEFAULT_GOAL := info

.PHONY: info help encrypt decrypt install-ssh install-git install-helix clean

info: ## Show current config and targets
	@echo "BUNDLE_PATH = $(BUNDLE_PATH)"
	@echo "AGE_PATH    = $(AGE_PATH)"
	@echo "REPO_PATH   = $(REPO_PATH)"
	@echo "SSH_DIR     = $(SSH_DIR)"
	@echo
	@$(MAKE) --no-print-directory help

help: ## List available targets
	@echo "Available targets:"
	@grep -E '^[a-zA-Z0-9_.-]+:.*?##' $(lastword $(MAKEFILE_LIST)) \
	| sed -E 's/^([^:]+):.*?## (.*)/\1##\2/' \
	| while IFS="##" read -r target desc; do \
		if [ "$$target" = "$(DEFAULT_GOAL)" ]; then \
			printf "  * make %-15s %s\n" "$$target" "$$desc"; \
		else \
			printf "    make %-15s %s\n" "$$target" "$$desc"; \
		fi; \
	done

encrypt: ## Bundle repo and encrypt with age (passphrase)
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

decrypt: ## Decrypt bundle and clone repo
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

install-packages: ## Install system packages
	. /etc/os-release && echo "Running ./scripts/$${ID}.sh" && exec sudo ./scripts/$${ID}.sh

install-ssh: ## Install SSH keys and config from repo
	@mkdir -p "$(SSH_DIR)"
	@if [ ! -d "$(REPO_PATH)/ssh" ]; then \
		echo "Error: '$(REPO_PATH)/ssh' not found."; \
		exit 1; \
	fi
	cp -r "$(REPO_PATH)/ssh/." "$(SSH_DIR)/"
	chmod 700 "$(SSH_DIR)"
	find "$(SSH_DIR)" -type f -name "id_*" ! -name "*.pub" -exec chmod 600 {} \;
	find "$(SSH_DIR)" -type f -name "id_*.pub" -exec chmod 644 {} \; || true
	@if [ -f "$(SSH_DIR)/config" ]; then \
		chmod 644 "$(SSH_DIR)/config"; \
	fi

install-git: ## Configure global git identity
	git config --global user.email "os@safl.dk"
	git config --global user.name  "Simon A. F. Lund"

install-helix: ## Install or update Helix config from ./helix
	@mkdir -p "$(HOME)/.config"
	@if [ ! -d "helix" ]; then \
		echo "Error: 'helix' directory not found in current path."; \
		exit 1; \
	fi
	@if [ -d "$(HOME)/.config/helix" ]; then \
		echo "Updating existing Helix config..."; \
		cp -r helix/* "$(HOME)/.config/helix/"; \
	else \
		echo "Installing new Helix config..."; \
		cp -r helix "$(HOME)/.config/helix"; \
	fi

install-rust: ## Install rust via rustup
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

install-zellij: ## Install zellij via cargo
	OPENSSL_NO_VENDOR=1 cargo install zellij

clean: ## Remove local (decrypted) bundle if present
	@rm -f "$(BUNDLE_PATH)"
