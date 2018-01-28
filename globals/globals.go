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
)

var (
	/* constant-ish */
	TMPLDIR string = filepath.FromSlash(PUBLIC + "/html")  // location of all templates
	POSTDIR string = filepath.FromSlash(PUBLIC + "/files") // location of all post media
	POSTDB  string = "posts.db"                            // sqlite3 database
)
