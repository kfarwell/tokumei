// Copyright (c) 2009 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/**
 * @fileoverview CFInstall.js provides a set of utilities for managing
 * the Chrome Frame detection and installation process.
 * @author slightlyoff@google.com (Alex Russell)
 *
 * Chrome Frame is being retired. As a result, this script now silently ignores
 * requests to prompt the user to install Chrome Frame.
 */

(function(scope) {
  // bail if we'd be over-writing an existing CFInstall object
  if (scope['CFInstall']) {
    return;
  }

  /////////////////////////////////////////////////////////////////////////////
  // Plugin Detection
  /////////////////////////////////////////////////////////////////////////////

  /**
   * Checks to find out if ChromeFrame is available as a plugin
   * @return {Boolean}
   */
  var isAvailable = function() {
    return false;
  };

  var CFInstall = {};

  /**
   * Checks to see if Chrome Frame is available, if not, prompts the user to
   * install. Once installation is begun, a background timer starts,
   * checkinging for a successful install every 2 seconds. Upon detection of
   * successful installation, the current page is reloaded, or if a
   * 'destination' parameter is passed, the page navigates there instead.
   * @param {Object} args A bag of configuration properties. Respected
   *    properties are: 'mode', 'url', 'destination', 'node', 'onmissing',
   *    'preventPrompt', 'oninstall', 'preventInstallDetection', 'cssText', and
   *    'className'.
   * @public
   */
  CFInstall.check = function(args) {
      if (window.console && console.warn){
          console.warn(
              "Google Chrome Frame is being retired, so the CFInstall.check " +
              "method no longer notifies the user; see " +
              "http://blog.chromium.org/2013/06/retiring-chrome-frame.html " +
              "for more information.");
      }
  };

  CFInstall._force = false;
  CFInstall._forceValue = false;
  CFInstall.isAvailable = isAvailable;

  // expose CFInstall to the external scope. We've already checked to make
  // sure we're not going to blow existing objects away.
  scope.CFInstall = CFInstall;

})(this['ChromeFrameInstallScope'] || this);
