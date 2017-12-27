/* Copyright (c) 2017 Tokumei authors.
 * This software package is licensed for use under the ISC license.
 * See LICENSE for details.
 *
 * Tokumei is a simple, self-hosted microblogging platform. */

package posts

import (
	"crypto/rand"
	"encoding/base64"

	"golang.org/x/crypto/bcrypt"
)

// A DeleteCode is a simple association of a hashed passphrase to a Post or
// Reply.
type DeleteCode struct {
	Id     int64
	Parent int64 // negative if post is not a reply
	Hash   string
	Salt   string
}

// NewDeleteCode() create a new fully qualified DeleteCode. If the DeleteCode
// is for a Post, then the parent parameter should be negative.
func NewDeleteCode(id, parent int64, code string) *DeleteCode {
	// return nil if ID is invalid; IDs start at 1.
	// if code is an empty string then no DeleteCode should be made
	if id <= 0 || code == "" {
		return nil
	}

	// generate a random 32-byte salt
	buf := make([]byte, 32)
	if _, err := rand.Read(buf); err != nil {
		return nil
	}
	salt := base64.URLEncoding.EncodeToString(buf)

	code += salt

	// hash the salted password with bcrypt (which itself uses an algorithmic
	// salt)
	hash, err := bcrypt.GenerateFromPassword([]byte(code), bcrypt.DefaultCost)
	if err != nil {
		return nil
	}

	return &DeleteCode{
		Id:     id,
		Parent: parent,
		Hash:   string(hash),
		Salt:   salt,
	}
}
