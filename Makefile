NAME=go-daemon-debian-pkg-skel
VERSION=0.1
BIN=$(NAME)

BUILD_DIR=$(HOME)/debian/tmp/$(NAME)
PKG_NAME=$(NAME)-$(VERSION)
PKG=$(BUILD_DIR)/$(PKG_NAME).tar.gz
DEB_TARGET_DIR=$(HOME)/debian/$(NAME)

all: build

# Creates the .orig tarball required for the package
tarball:
	rm -rf $(BUILD_DIR)
	mkdir -p $(BUILD_DIR)
	git archive --output=$(PKG) --prefix=$(PKG_NAME)/ HEAD
	mv $(PKG) $(BUILD_DIR)/$(NAME)_$(VERSION).orig.tar.gz

clean:
	rm -f $(BIN)

debpkg: tarball 
	mkdir -p $(DEB_TARGET_DIR)
	# Prevents overwriting a good tarball
	! test -f $(DEB_TARGET_DIR)/$(NAME)_$(VERSION).orig.tar.gz
	cd $(BUILD_DIR) && \
		tar xzf $(NAME)_$(VERSION).orig.tar.gz && \
	  cd $(NAME)-$(VERSION) && \
		debuild -S && rm -rf $(BUILD_DIR)/$(NAME)-$(VERSION) && \
		mv $(BUILD_DIR)/* $(DEB_TARGET_DIR)

# Builds the Go binary
build:
	GOPATH=$(PWD)/vendor go build -o $(NAME)

# Vendors all the deps
update-deps:
	rm -rf vendor/src
	GOBIN=$(PWD)/vendor/bin GOPATH=$(PWD)/vendor go get
	rm -rf vendor/pkg
	rm -rf vendor/bin
	find vendor/src -type d -name '.git' -o -name '.hg' | xargs rm -rf
	find vendor/src -type f -name '.gitignore' -o -name '.hgignore' | xargs rm

.PHONY: update-deps clean

