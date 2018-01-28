/* Copyright (c) 2017-2018 Tokumei authors.
 * This software package is licensed for use under the ISC license.
 * See LICENSE for details.
 *
 * Tokumei is a simple, self-hosted microblogging platform. */

package mimetype

import "strings"

// Zip based files are awful and can only really be verified by extension
// because there is no concrete identifying information. This function will
// check if a byte slice is a zip by signature, check the file extension, and
// also look for properties that define a well-behaving file.
func zipIdent(b []byte, ext string) (string, error) {
	s := string(b)
	if !strings.HasPrefix(s, "\x50\x4b\x03\x04") {
		return "", ErrBadFile
	}
	switch strings.ToLower(ext) {
	case "jar":
		if strings.Index(s, "class") != -1 || strings.Index(s, "CLASS") != -1 {
			return "application/jar", nil
		} else {
			return "", ErrBadExt
		}
	case "odt":
	}
	return "application/zip", nil
}
