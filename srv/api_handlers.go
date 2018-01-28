/* Copyright (c) 2017-2018 Tokumei authors.
 * This software package is licensed for use under the ISC license.
 * See LICENSE for details.
 *
 * Tokumei is a simple, self-hosted microblogging platform. */

// This file contains handlers for API endpoints only; GET API functions return
// only JSON responses, and POST API functions accept only multipart/form-data.
// Multipurpose/dynamic and logic heavy routings belong in dynamic_handlers.go

package srv

import (
	"encoding/json"
	"fmt"
	"net/http"
	"net/url"

	"gitlab.com/tokumei/tokumei/posts"
)

/* get api-only endpoints */

// queries of the following forms are permitted, where
// * n, m are integers and h, l are the literal characters h and l
//   /posts			: returns all posts
//   /posts?h=n		: returns the first n posts
//   /posts?l=m		: returns all posts excluding the first m posts
//   /posts?h=n&l=m : returns the first n posts excluding the first m posts
//
// other query parameters are ignored
func getPostsHandler(w http.ResponseWriter, r *http.Request) {
	switch r.Method {
	case "GET":
		if r.URL.Path != Routes["allposts"] {
			errorHandler(w, r, http.StatusNotFound)
			return
		}
		q, err := url.ParseQuery(r.URL.RawQuery)
		if err != nil {
			errorHandler(w, r, http.StatusBadRequest)
			return
		}
		h, herr := UrlIntQuery(q, "h")
		l, lerr := UrlIntQuery(q, "l")
		if (herr != nil && herr != ErrKeyNotFound) || (lerr != nil && lerr != ErrKeyNotFound) {
			errorHandler(w, r, http.StatusBadRequest)
			return
		}
		posts := posts.GetPostsRange(l, h)
		res, err := json.MarshalIndent(posts, "", "  ")
		if err != nil {
			errorHandler(w, r, http.StatusInternalServerError)
			return
		}
		w.Header().Set("Content-Type", "application/json")
		fmt.Fprintf(w, string(res))
	default:
		errorHandler(w, r, http.StatusUnauthorized)
	}
}

// getPostNumHandler will return the postnum to the client
func getPostNumHandler(w http.ResponseWriter, r *http.Request) {
	n, err := posts.GetPostNum()
	if err != nil {
		errorHandler(w, r, http.StatusInternalServerError)
	}
	w.Header().Set("Content-Type", "application/json")
	fmt.Fprintf(w, "%d", n)
}

/* post api-only endpoints */

// reportHandler will post a report from the request submitted to /report
func reportHandler(w http.ResponseWriter, r *http.Request) {
	switch r.Method {
	case "POST":
		// handle form data (post id, reply id, type, reason)
		// negative reply id can indicate that the report is for the post
	default:
		errorHandler(w, r, http.StatusBadRequest)
	}

}
