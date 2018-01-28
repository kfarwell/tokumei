/* Copyright (c) 2017-2018 Tokumei authors.
 * This software package is licensed for use under the ISC license.
 * See LICENSE for details.
 *
 * Tokumei is a simple, self-hosted microblogging platform. */

package mimetype

import (
	"encoding/binary"
	"fmt"
)

// RIFF containers can hold lots of data types; this function checks for a few
// common ones
func riffIdent(b []byte) (string, error) {
	if string(b[0:4]) != "RIFF" {
		return "", ErrBadFile
	}
	size := uint32(len(b))
	reportedSize := binary.LittleEndian.Uint32(b[4:8])
	if reportedSize != size-8 {
		fmt.Printf("%d %d\n", reportedSize, size)
		return "", ErrBadFile
	}
	if isWebp(b) {
		return "image/webp", nil
	} else if isWav(b) {
		return "audio/x-wav", nil
	} else if isAvi(b) {
		return "video/x-msvideo", nil
	}
	return "", ErrUnsupportedFile
}

// data from https://developers.google.com/speed/webp/docs/riff_container
func isWebp(b []byte) bool {
	return string(b[8:12]) == "WEBP"
}

func isWav(b []byte) bool {
	return string(b[8:12]) == "WAVE"
}

func isAvi(b []byte) bool {
	return string(b[8:12]) == "AVI\x20"
}
