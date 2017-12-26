#!/bin/bash

# Copyright (c) 2017 Tokumei authors.
# This software package is licensed for use under the ISC license.
# LICENSE for details.
#
# Tokumei is a simple, anonymous, self-hosted microblogging platform.
# This script installs necessary web components and sets up configuration files.
# You need to run this before you can start using Tokumei.

JQUERY_DIST="https://code.jquery.com/jquery-3.2.1.min.js"
MATERIALIZE_DIST="https://github.com/Dogfalo/materialize/releases/download/v0.100.2/materialize-v0.100.2.zip"
MDI_DIST="https://github.com/Templarian/MaterialDesign-Webfont/archive/master.tar.gz"
DIR_JS="public/js"
DIR_CSS="public/css"
DIR_FONT="public/fonts"

# install web-client ui components
mkdir -p $DIR_JS
mkdir -p $DIR_CSS
mkdir -p $DIR_FONT

which npm 1>/dev/null 2>&1
if [ $? -eq 0 ]; then
    npm install materialize-css mdi 1>/dev/null 2>&1
    cp node_modules/jquery/dist/jquery.min.js       $DIR_JS
    cp node_modules/hammerjs/hammer.min.js          $DIR_JS
    cp -r node_modules/materialize-css/dist/js/*    $DIR_JS
    cp -r node_modules/materialize-css/dist/css/*   $DIR_CSS
    cp -r node_modules/materialize-css/dist/fonts/* $DIR_FONT
    cp -r node_modules/mdi/css/*                    $DIR_CSS
    cp -r node_modules/mdi/fonts/*                  $DIR_FONT
    rm -rf node_modules/
else
    wget -O $DIR_JS/jquery.js       $JQUERY_DIST 
    wget -O /tmp/materialize.zip    $MATERIALIZE_DIST
    unzip /tmp/materialize.zip
    mv materialize/js/*             $DIR_JS
    mv materialize/css/*            $DIR_CSS
    mv materialize/fonts/*          $DIR_FONT
    rm -rf materialize /tmp/materialize.zip
    wget -O /tmp/mdi.tar.gz         $MDI_DIST
    tar xzf /tmp/mdi.tar.gz
    mv Material* mdi/
    mv mdi/css/*                    $DIR_CSS
    mv mdi/fonts/*                  $DIR_FONT
    rm -rf mdi /tmp/mdi.tar.gz
fi

