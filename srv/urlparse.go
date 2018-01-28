/* Copyright (c) 2017-2018 Tokumei authors.
 * This software package is licensed for use under the ISC license.
 * See LICENSE for details.
 *
 * Tokumei is a simple, self-hosted microblogging platform. */

package srv

import (
	"errors"
	"net/url"
	"strconv"
)

var (
	ErrEmptyKey    error = errors.New("urlparse: illegal empty key")
	ErrKeyNotFound error = errors.New("urlpase: key not found in url query")
)

// UrlIntQuery() returns an integer value from a url.Values identified by key.
// Returns -1 and ErrKeyNotFound if the key was not in the URL query. Returns
// ErrEmptyKey if key is supplied as an empty string.
func UrlIntQuery(v url.Values, key string) (int, error) {
	if key == "" {
		return -1, ErrEmptyKey
	}
	raw := v.Get(key)
	if raw == "" {
		return -1, ErrKeyNotFound
	}
	ret, err := strconv.ParseInt(raw, 10, 64)
	return int(ret), err
}
