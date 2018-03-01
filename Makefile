# Copyright (c) 2017-2018 Tokumei authors.
# This software package is licensed for use under the ISC license.
# See LICENSE for details.
#
# Tokumei is a simple, self-hosted microblogging platform.
# This Makefile simplifies the build and installation process for the software.

BIN = tokumei

.PHONY: all frontend clean test
# build Tokumei and get the front-end dependencies
all: frontend
	go build -i -o $(BIN) ./cmd

# install front end dependancies
frontend:
	./install.sh

# remove the compiled binary
clean:
	rm $(BIN)

# test code coverage of each package in Tokumei
# TODO: add more tests
test:
	go test -cover ./mimetype	
