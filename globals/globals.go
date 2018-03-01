/* Copyright (c) 2017-2018 Tokumei authors.
 * This software package is licensed for use under the ISC license.
 * See LICENSE for details.
 *
 * Tokumei is a simple, self-hosted microblogging platform. */

// Package globals constains cross-package constants. It exists as a glue
// between Tokumei packages
package globals

import "path/filepath"

// VERSION is the semantic version number of this release of Tokumei
const VERSION string = "2.0.0-dev"

/* constant-ish */
var (
	// PUBLIC is the location of non-private files for the server.
	PUBLIC string = "public"
	// TMPLDIR is the location of all templates.
	TMPLDIR string = filepath.FromSlash(PUBLIC + "/html")
	// POSTDIR is the location of all post media. This directory is subdivided
	// into directories by post number.
	POSTDIR string = filepath.FromSlash(PUBLIC + "/files")
	// POSTDB is the location of the sqlite3 database.
	POSTDB string = "posts.db"
)
