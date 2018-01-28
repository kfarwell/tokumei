/* Copyright (c) 2017-2018 Tokumei authors.
 * This software package is licensed for use under the ISC license.
 * See LICENSE for details.
 *
 * Tokumei is a simple, self-hosted microblogging platform. */

package mimetype

import (
	"strings"
	"sync"
)

const (
	RIFF_CONTAINER string = "RIFF?"
	MKV_CONTAINER  string = "MKV?"
	XML_FILETYPE   string = "XML?"
	ZIP_ARCHIVE    string = "ZIP?"
	ISO_BASEMEDIA  string = "ISOBASE?"
)

// this table associates so-called "magic numbers" with internet mimetypes
// some data from https://en.wikipedia.org/wiki/List_of_file_signatures
var (
	magicPrefixTable = struct {
		sync.RWMutex
		m map[string]string
	}{
		m: map[string]string{
			/* images */
			"\x00\x00\x01\x00":  "image/vnd.microsoft.icon", // ico
			"\xff\xd8\xff":      "image/jpeg",               // jpeg | jpg
			"\x89PNG\r\n\x1a\n": "image/png",                // png
			"GIF87a":            "image/gif",                // non-animated gif
			"GIF89a":            "image/gif",                // (possibly) animated gif
			"\x4d\x4d\x00\x2a":  "image/tiff",               // tiff (big endian)
			"\x49\x49\x2a\x00":  "image/tiff",               // tiff (little endian)
			"BM":                "image/bmp",                // bmp | dib

			/* audio */
			"\xff\xfb": "audio/mpeg",    // mp3 without tags or with ID3v1 tag
			"ID3":      "audio/mpeg",    // mp3 (ID3)
			"OggS":     "audio/ogg",     // ogg | opus
			"fLaC":     "audio/x-flac",  // flac
			"<svg":     "image/svg+xml", // svg

			/* video */
			"\x00\x00\x01\xba":                                                 "video/mpeg",     // mpeg | mpg
			"\x30\x26\xb2\x75\x8e\x66\xcf\x11\xa6\xd9\x00\xaa\x00\x62\xce\x6c": "video/x-ms-asf", // wmv | wma | asf
			/* documents */
			"%PDF": "application/pdf",        // pdf
			"%!PS": "application/postscript", // ps

			/* archives and disks */
			"\x50\x4b\x05\x06": "application/zip",       // empty zip archive
			"\x50\x4b\x07\x08": "application/zip",       // spanned zip archive
			"CD001":            "application/iso-image", // iso

			/* misc formats */
			"MThD": "application/midi", // mid | midi (descriptor for audio engines)

			/* inconclusive by prefix */
			"RIFF":             RIFF_CONTAINER, // one of any RIFF container formats
			"\x1a\x45\xdf\xa3": MKV_CONTAINER,  // either matroska or webm
			"<?xml":            XML_FILETYPE,   // one of many xml types
			"<!doctype":        XML_FILETYPE,   // one of many xml types
			"\x50\x4b\x03\x04": ZIP_ARCHIVE,    // one of many formats based on zip archives
			"ftyp":             ISO_BASEMEDIA,  // mp4, m4a, mov, 3gp...
		},
	}
)

func trimPrefix(b []byte, ext string) []byte {
	switch strings.ToLower(ext) {
	// ISO base media container formats write chunk size first, then file
	// identifier; the first four bytes are a long-int size which must be
	// discarded to access the magic number
	case "m4a": // mp4 audio
		fallthrough
	case "m4b": // bookmarkable mp4 audio
		fallthrough
	case "m4p": // protected mp4 audio
		fallthrough
	case "m4v": // apple drm video :(
		fallthrough
	case "mp4": // mp4 video
		fallthrough
	case "mov": // quicktime movie
		fallthrough
	case "qt": // quicktime movie
		fallthrough
	case "3gpp":
		fallthrough
	case "3gp":
		return b[4:]
	}
	return b
}

func magicLookup(b []byte, ext string) (string, error) {
	// trim file to find header if required; this is trusting the extension
	b = trimPrefix(b, ext)
	s := string(b)
	// lookup from table distrusting the extension
	magicPrefixTable.RLock()
	defer magicPrefixTable.RUnlock()
	for prefix, mime := range magicPrefixTable.m {
		if strings.HasPrefix(s, prefix) {
			return mime, nil
		}
	}
	return "", ErrUnsupportedFile
}

func embedLookup(mtype string) string {
	if strings.HasPrefix(mtype, "image") {
		return "img"
	} else if strings.HasPrefix(mtype, "audio") {
		return "audio"
	} else if strings.HasPrefix(mtype, "video") {
		return "video"
	}
	return ""
}
