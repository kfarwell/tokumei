/* Copyright (c) 2017 Tokumei authors.
 * This software package is licensed for use under the ISC license.
 * See LICENSE for details.
 *
 * Tokumei is a simple, self-hosted microblogging platform. */

// Package mimetype contains functions and definitions which are used to attempt
// to verify a file by its magic bytes before asserting a mimetype.
//
// This package exists becauses Go's built in mime package only associates
// mimetypes with file extensions. The builtin functionality is insufficient
// for secure web applications because one can easily lie about the file
// extension. This package aims to at least verify files by some parts of their
// their structural definitions before asserting the mimetype.
//
// In case the file cannot possibly be verified by structural definition, then
// this falls back onto the stdlib's mime package to determine an unverifiable
// mimetype.
package mimetype

import (
	"errors"
	"io/ioutil"
	"mime"
	"os"
	"path/filepath"
	"strings"
)

// FileType is a file descriptor containing mime information and other basic
// information required to serve and render a file properly in a browser.
//
// If using the template package, then querying the FileType.HtmlEmbed will be
// useful to determine whether <img>, <audio>, or <video> tags should be used to
// display the media if applicable.
//
// For example:
//	{{if eq .File.HtmlEmbed "img"}}
//	<img src="/path/to/foo" alt="foo img"/>
//	{{else if eq .File.HtmlEmbed "audio"}}
//	<audio src="/path/to/foo" controls></audio>
//	{{else if eq .File.HtmlEmbed "video"}}
//	<video src="/path/to/foo" controls></video>
//	{{else}}
//	<p>No preview is available for this file :(</p>
//	{{end}}
//
// Mimetype and Ext will contain the determined mimetype of the file and the
// extension (if any). If there is no file extension, the Mimetype is assumed to
// be "text/plain". If the mimetype could not be determined by this package and
// the built in "mime" package had to be used as a fall-back, then
// VerifiedSignature is false and it cannot be guaranteed that the file is
// trustworthy.
type FileType struct {
	Mimetype          string // the internet mime-type idenfier
	Ext               string // the human readable file extension
	HtmlEmbed         string // HTML embed type if applicable
	VerifiedSignature bool   // true if file was able to be verified by structural signature
	Size              uint64 // the size of the file in bytes
}

var (
	ErrBadFile         = errors.New("mime: file is malformed")
	ErrUnsupportedFile = errors.New("mime: file type is not supported")
	ErrBadExt          = errors.New("mime: file has a mismatched extension")
)

// Returns a FileType descriptor for the file located at the supplied path.
// If a file specified by path has no extension, an unverified file descriptor
// is returned with the mimetype "text/plain" and ErrBadFile is returned.
// Known file extensions are enforced with the proper magic bytes so files are
// both properly identifiable by computers and humans. It would likely be
// erroneous to write PDF data to a web application but supply this file with a
// .txt extension; since this is misleading to users, it is an error.
func GetFileType(path string) (*FileType, error) {
	// verify the file exists and is not a directory
	if f, err := os.Stat(path); os.IsNotExist(err) || f.IsDir() {
		return nil, ErrBadFile
	}
	b, err := ioutil.ReadFile(path)
	if err != nil {
		return nil, err
	}
	// get extension and lookup mimetype by checking file signatures
	ext := filepath.Ext(path)
	if ext == "" {
		ret := FileType{
			Mimetype:          "text/plain",
			Ext:               "",
			HtmlEmbed:         "",
			VerifiedSignature: false,
			Size:              uint64(len(b)),
		}
		return &ret, ErrBadFile
	}
	mtype, err := magicLookup(b, ext)
	verified := false
	if err != nil && err != ErrUnsupportedFile {
		return nil, err
	}
	// if the file is some container format that must be further analyzed, do so
	switch mtype {
	case RIFF_CONTAINER:
		mtype, err = riffIdent(b)
	case MKV_CONTAINER:
		mtype, err = mkvIdent(b)
	case XML_FILETYPE:
		mtype, err = xmlIdent(b)
	case ZIP_ARCHIVE:
		mtype, err = zipIdent(b, ext)
	case ISO_BASEMEDIA:
		mtype, err = isoMediaIdent(b, ext)
	}
	// fall back on Go's built-in checking by extension if file signature could
	// not be verified
	if err == nil {
		verified = true
	} else if err == ErrUnsupportedFile {
		mtype = mime.TypeByExtension(ext)
	} else {
		return nil, err
	}

	knownExts, err := mime.ExtensionsByType(mtype)
	isKnownExt := false
	for _, v := range knownExts {
		// for text formats like xml; Go stdlib specifies an annoying charset
		// attribute which is not even guaranteed to be correct; strip this
		if strings.Index(v, ";") >= 0 {
			v = v[0:strings.Index(v, ";")]
		}
		if ext == v {
			isKnownExt = true
			break
		}
	}
	if !isKnownExt {
		//fmt.Println(knownExts)
		//fmt.Println(mime.TypeByExtension(ext))
		return nil, ErrBadExt
	}

	embed := embedLookup(mtype)

	ret := FileType{
		Mimetype:          mtype,
		Ext:               ext,
		HtmlEmbed:         embed,
		VerifiedSignature: verified,
		Size:              uint64(len(b)),
	}
	return &ret, nil
}
