/* Copyright (c) 2017 Tokumei authors.
 * This software package is licensed for use under the ISC license.
 * See LICENSE for details.
 *
 * Tokumei is a simple, self-hosted microblogging platform. */

package globals

import "path/filepath"

const (
	VERSION string = "2.0"
	PUBLIC  string = "public"
	CFG     string = "cfg"
	SRV     string = "srv"
)

// CFGFILE is the path to the JSON formatted config file for this Tokumei server.
// See the tokumei/srv package to better understand server configuration.
var CFGFILE string = filepath.FromSlash(CFG + "/config.json")
var (
	/* constant-ish */
	TMPLDIR string = filepath.FromSlash(PUBLIC + "/html")  // location of all templates
	POSTDIR string = filepath.FromSlash(PUBLIC + "/files") // location of all post media
	POSTDB  string = "posts.db"                            // sqlite3 database

	/* real variables :) */
	PORT    string = "1337" // can be overridden by settings in CFGFILE
	Verbose bool   = false
)
