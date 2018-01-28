/* Copyright (c) 2017-2018 Tokumei authors.
 * This software package is licensed for use under the ISC license.
 * See LICENSE for details.
 *
 * Tokumei is a simple, self-hosted microblogging platform. */

// This file contains request handlers for pages that serve dynamic content to
// the web client. POST/GET only handlers and helper functions are located in
// api_handlers.go

package srv

import (
	"errors"
	"fmt"
	"log"
	"net/http"
	"os"
	"strconv"
	"strings"

	"gitlab.com/tokumei/tokumei/posts"
	"tokumei.co/tokumei/mimetype"
)

var (
	errBadRequest            = errors.New("400 Bad Request")
	errRequestEntityTooLarge = errors.New("413 Request Entity Too Large")
	errUnsupportedMediaType  = errors.New("415 Unsupported Media Type")
	errUnprocessableEntity   = errors.New("422 Unprocessable Entity")
	errInternalServerError   = errors.New("500 Internal Server Error")
)

// GET only; render the HTML timeline consisting of all posts in chronological
// order
func timelineHandler(w http.ResponseWriter, r *http.Request) {
	if r.URL.Path != Routes["timeline"] {
		errorHandler(w, r, http.StatusNotFound)
		return
	}
}

// GET only; render the HTML trending index consisting of trending posts/tags
func trendingHandler(w http.ResponseWriter, r *http.Request) {
	if r.URL.Path != Routes["trending"] {
		errorHandler(w, r, http.StatusNotFound)
		return
	}
}

// GET only; render the HTML index consisting of posts filtered by followed tags
func followingHandler(w http.ResponseWriter, r *http.Request) {
	if r.URL.Path != Routes["following"] {
		errorHandler(w, r, http.StatusNotFound)
		return
	}
}

// POST/GET; postHandler handles GET and POST requests to the posts Route.
// Delivers JSON response a GET to /p/n.json or a rendered template to the
// the client if the request is /p/n .
// Sends a post if the expected form fields are present in a POST request.
func postHandler(w http.ResponseWriter, r *http.Request) {
	switch r.Method {
	case "GET":
		// redirect to timeline from /p/
		if r.URL.Path == Routes["post"] {
			http.Redirect(w, r, Routes["timeline"], http.StatusSeeOther)
			return
		}
		// otherwise handle get request
		request := strings.TrimPrefix(r.URL.Path, Routes["post"])
		jsonResponse := strings.HasSuffix(request, ".json")
		request = strings.TrimSuffix(request, ".json")

		n, err := strconv.ParseInt(request, 10, 64)
		if err != nil || n < 0 {
			errorHandler(w, r, http.StatusNotFound)
			return
		}
		p, err := posts.Lookup(n)
		if err != nil {
			log.Println(err)
			errorHandler(w, r, http.StatusNotFound)
			return
		}
		if jsonResponse {
			w.Header().Set("Content-Type", "application/json")
			if p != nil {
				fmt.Fprint(w, *p)
			} else { // shouldn't ever do this
				fmt.Fprint(w, "null")
				log.Println("Responded with a nil post. This shouldn't happen.")
			}
			return
		} else {
			tmpl := TplCollection.Lookup("post")
			if tmpl == nil {
				errorHandler(w, r, http.StatusInternalServerError)
				return
			}

			data := struct {
				Conf        Settings
				Post        *posts.Post
				Attachments []mimetype.FileType
			}{
				Conf,
				p,
				p.GetAttachments(),
			}
			if err := tmpl.Execute(w, data); err != nil {
				log.Fatalf("template execution: %s", err)
			}
		}
	// TODO(kfarwell)
	// Add recaptcha support.
	case "POST":
		fmt.Println("IN POST POST")

		// check if the post can be made with the provided fields
		if Conf.Features.ProvideApiKeys && Conf.PostConf.RequireCaptcha {
			// TODO handle API keys with captcha
		} else if Conf.PostConf.RequireCaptcha {
			// TODO handle captcha without API keys
		}

		/* handle a request to make a brand new post */
		if r.URL.Path == Routes["post"] {
			if p, err := makePostFromReq(r); p == nil {
				switch err {
				case errBadRequest:
					errorHandler(w, r, http.StatusBadRequest)
				case errRequestEntityTooLarge:
					errorHandler(w, r, http.StatusRequestEntityTooLarge)
				case errUnsupportedMediaType:
					errorHandler(w, r, http.StatusUnsupportedMediaType)
				case errUnprocessableEntity:
					errorHandler(w, r, http.StatusUnprocessableEntity)
				case errInternalServerError:
					fallthrough
				default:
					errorHandler(w, r, http.StatusInternalServerError)
				}
			} else {
				QueuePost(p)
			}
			return
		}
		/* otherwise try to handle replies */
		// TODO(krourke)
		// get post ID for reply
		// create reply from request
		// submit reply

	default:
		errorHandler(w, r, http.StatusUnauthorized)
	}
}

/* helper functions for dynamic pages */

// makePostFromReq() mkaes a new post from the form data found in the supplied
// http request.
func makePostFromReq(r *http.Request) (*posts.Post, error) {
	// save all multipart form data to disk
	if err := r.ParseMultipartForm(0); err != nil {
		log.Printf("could not parse MultipartForm: %s\n", err.Error())
		return nil, errBadRequest
	}
	// parse key-value pairs
	message := r.FormValue("message")
	if message == "" {
		log.Println("post rejected due to empty message body")
		return nil, errBadRequest
	} else if len(message) > Conf.PostConf.CharLimit {
		log.Printf("post rejected because message longer than limit %d\n", Conf.PostConf.CharLimit)
		return nil, errUnprocessableEntity
	}
	tagstr := r.FormValue("tags")
	password := r.FormValue("password")

	// parse attachments and get a list of their locations on disk
	var attachments []string
	fhdrs := r.MultipartForm.File["attachment"]
	// check attachment num constraints ~
	if len(fhdrs) > MAX_ATTACHMENTS || len(fhdrs) < MIN_ATTACHMENTS {
		log.Println("post rejected because message has invalid number of attachments")
	}
	// TODO(krourke/kfarwell) discard original file names; strip metadata
	// this is particularly challenging and may require we write a new package
	for _, fh := range fhdrs {
		f, err := fh.Open()
		if err != nil {
			log.Printf("could not open post attachment file: %s\n", err.Error())
			return nil, errInternalServerError
		}
		// check file is allowed mimetype and reject unverified files
		if ftyp, err := mimetype.GetFileType(f.(*os.File).Name()); err != nil {
			log.Println(err)
			return nil, errUnsupportedMediaType
		} else if !ftyp.VerifiedSignature {
			log.Printf("rejected file %s because file type could not be verified\n", f.(*os.File).Name())
			return nil, errUnsupportedMediaType
		} else if ftyp.Size > Conf.PostConf.MaxFileSize {
			log.Printf("rejected file %s because file is too larger than %dB\n", Conf.PostConf.MaxFileSize)
			return nil, errRequestEntityTooLarge
		}
		// get file name and append to attachment slice
		attachments = append(attachments, f.(*os.File).Name())
		f.Close()
	}
	// make a new Post
	p := posts.NewPost(message, password, posts.ParseTagString(tagstr), attachments)
	return p, nil
}
