# Copyright (c) 2017-2018 Tokumei authors.
# This software package is licensed for use under the ISC license.
# See LICENSE for details.
#
# Tokumei is a simple, self-hosted microblogging platform.
# This Makefile simplifies the build and installation process for the software.

BIN = tokumei

.PHONY: all backend frontend config clean test
backend:
	go get -u github.com/mattn/go-sqlite3
	go get -u gopkg.in/urfave/cli.v1
	go get -u golang.org/x/crypto/bcrypt
	go build -i -o $(BIN) ./cmd

# build Tokumei and get the front-end dependencies
all: backend frontend config

# install front end dependancies
frontend:
	./install.sh

# configure the tokumei installation
config:
	./genconfs.sh

# remove the compiled binary
clean:
	rm $(BIN)

# test code coverage of each package in Tokumei
# TODO: add more tests
test:
	go test -cover ./mimetype	
