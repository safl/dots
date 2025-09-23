BUNDLE_PATH := $(HOME)/secrets.bundle
AGE_PATH := $(BUNDLE_PATH).age
REPO_PATH := $(HOME)/git/secrets

.PHONY: encrypt decrypt install-ssh default info

default: info
	@echo ""
	@echo "Usage:"
	@echo "  make encrypt     # Create an encrypted git-bundle from secrets-repo"
	@echo "  make decrypt     # Restore secrets-repo from encrypted git-bundle"
	@echo "  make install-ssh # Install SSH keys and config from secrets-repo"
	@echo "  make install-git # Configures git"

info:
	@echo "BUNDLE_PATH = $(BUNDLE_PATH)"
	@echo "AGE_PATH    = $(AGE_PATH)"
	@echo "REPO_PATH   = $(REPO_PATH)"

encrypt:
	@if [ -e "$(AGE_PATH)" ]; then \
		echo "Error: Encrypted bundle '$(AGE_PATH)' already exists. Remove it before running encrypt."; \
		exit 1; \
	fi
	@if [ ! -d "$(REPO_PATH)" ]; then \
		echo "Error: Repository('$(REPO_PATH)') does not exist; nothing to encrypt."; \
		exit 1; \
	fi
	cd "$(REPO_PATH)" && \
		git bundle create "$(BUNDLE_PATH)" --all
	cd "$(HOME)" && \
		age -e -p -o "$(AGE_PATH)" "$(BUNDLE_PATH)" && \
		rm "$(BUNDLE_PATH)"

decrypt:
	@if [ ! -e "$(AGE_PATH)" ]; then \
		echo "Error: Encrypted bundle '$(AGE_PATH)' does not exist. Nohting to decrypt."; \
		exit 1; \
	fi	
	@if [ -e "$(REPO_PATH)" ]; then \
		echo "Error: Repository '$(REPO_PATH)' already exists. Remove it before running decrypt."; \
		exit 1; \
	fi
	@echo "Decrypting $(AGE_PATH) to $(BUNDLE_PATH)..."
	age -d -o "$(BUNDLE_PATH)" "$(AGE_PATH)" || { echo "Error: Decryption failed."; exit 1; }
	@echo "Cloning the bundle into $(REPO_PATH)..."
	git clone "$(BUNDLE_PATH)" "$(REPO_PATH)" || { echo "Error: Git clone failed."; exit 1; }
	rm "$(BUNDLE_PATH)"

install-ssh:
	@mkdir -p "$(HOME)/.ssh"
	@if [ -d "$(REPO_PATH)/ssh" ]; then \
		cp -r "$(REPO_PATH)/ssh/." "$(HOME)/.ssh/"; \
	else \
		echo "Error: SSH directory not found in $(REPO_PATH)/ssh."; \
		exit 1; \
	fi
	@chmod 700 "$(HOME)/.ssh"
	@find "$(HOME)/.ssh" -type f -name "id_*" -exec chmod 600 {} \;
	@chmod 644 "$(HOME)/.ssh/config"
	@chown -R $$(id -u):$$(id -g) "$(HOME)/.ssh"

install-git:
	git config --global user.email "os@safl.dk"
	git config --global user.name "Simon A. F. Lund"
