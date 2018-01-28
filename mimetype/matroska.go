/* Copyright (c) 2017-2018 Tokumei authors.
 * This software package is licensed for use under the ISC license.
 * See LICENSE for details.
 *
 * Tokumei is a simple, self-hosted microblogging platform. */

package mimetype

// Mastroka video container formats may contain a few things, namely WEBM
func mkvIdent(b []byte) (string, error) {
	if string(b[0:4]) != "\x1a\x45\xdf\xa3" {
		return "", ErrBadFile
	}
	if isWebm(b) {
		return "video/webm", nil
	}
	return "video/x-matroska", nil
}

func isWebm(b []byte) bool {
	return string(b[15:19]) == "webm"
}
