/* Copyright (c) 2017 Tokumei authors.
 * This software package is licensed for use under the ISC license.
 * See LICENSE for details.
 *
 * Tokumei is a simple, self-hosted microblogging platform. */

package srv

import (
	/* Standard library packages */
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"net/url"
	"strconv"
	"strings"

	"gitlab.com/tokumei/tokumei/mimetype"
	"gitlab.com/tokumei/tokumei/posts"
)

// static page handler for error codes
func errorHandler(w http.ResponseWriter, r *http.Request, status int) {
	w.WriteHeader(status)

	tmpl := TplCollection.Lookup("error")
	if tmpl != nil {
		data := struct {
			Conf       Settings
			Status     int
			RequestUri string
		}{
			Conf,
			status,
			r.URL.RequestURI(),
		}
		if err := tmpl.Execute(w, data); err != nil {
			log.Fatalf("template execution: %s", err)
		}
	} else {
		switch status {
		case http.StatusBadRequest:
			fmt.Fprintf(w, "Error 400.")
		case http.StatusUnauthorized:
			fmt.Fprintf(w, "Error 401.")
		case http.StatusNotFound:
			fmt.Fprintf(w, "Error 404.")
		case http.StatusUnavailableForLegalReasons:
			fmt.Fprintf(w, "Error 451.")
		case http.StatusInternalServerError:
			fmt.Fprintf(w, "Error 500.")
		}
	}
}

/* static page handlers */
// generic page handler which will populate a page template with relevant values
// from the Conf struct
func staticPageHandler(w http.ResponseWriter, r *http.Request, name string) {
	if r.URL.Path != Routes[name] {
		errorHandler(w, r, http.StatusNotFound)
		return
	}
	tmpl := TplCollection.Lookup(name)
	if tmpl == nil {
		errorHandler(w, r, http.StatusInternalServerError)
		return
	}
	// just to be consistent with other handlers, we'll use fully qualified templates
	data := struct {
		Conf Settings
	}{Conf}
	if err := tmpl.Execute(w, data); err != nil {
		log.Fatalf("template execution: %s", err)
	}
}

func indexHandler(w http.ResponseWriter, r *http.Request) {
	staticPageHandler(w, r, "index")
}

func aboutHandler(w http.ResponseWriter, r *http.Request) {
	staticPageHandler(w, r, "about")
}

func apiDocHandler(w http.ResponseWriter, r *http.Request) {
	staticPageHandler(w, r, "apidoc")
}

func privacyHandler(w http.ResponseWriter, r *http.Request) {
	staticPageHandler(w, r, "privacy")
}

func donateHandler(w http.ResponseWriter, r *http.Request) {
	staticPageHandler(w, r, "donate")
}

func rulesHandler(w http.ResponseWriter, r *http.Request) {
	staticPageHandler(w, r, "rules")
}

/* dynamic page handlers */
// postHandler handles GET and POST requests to the posts Route.
// Delivers JSON response a GET to /p/n.json or
func postHandler(w http.ResponseWriter, r *http.Request) {
	switch r.Method {
	case "GET":
		if r.URL.Path == Routes["post"] {
			http.Redirect(w, r, Routes["timeline"], http.StatusSeeOther)
			return
		}
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
			} else {
				fmt.Fprint(w, "null")
			}
			return
		} else {
			tmpl := TplCollection.Lookup("post")
			if tmpl == nil {
				errorHandler(w, r, http.StatusInternalServerError)
				return
			}
			var attachment *mimetype.FileType
			if p.AttachmentUri != "" {
				attachment, err = mimetype.GetFileType("public" + p.AttachmentUri)
				if err != nil {
					log.Printf("attachment for post %d is unavailable.\n", p.Id)
				}
			}
			data := struct {
				Conf       Settings
				Post       *posts.Post
				Attachment *mimetype.FileType
			}{
				Conf,
				p,
				attachment,
			}
			if err := tmpl.Execute(w, data); err != nil {
				log.Fatalf("template execution: %s", err)
			}
		}
	case "POST":
		//		if err := r.ParseMultipartForm(0); err != nil {
		//			errorHandler(w, r, http.StatusBadRequest)
		//			return
		//		}
		//		_, fh, err := r.FormFile("attachment")
		//		f, err := fh.Open()

	default:
		errorHandler(w, r, http.StatusUnauthorized)
	}
}

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

func getPostNumHandler(w http.ResponseWriter, r *http.Request) {

}

/* post api-only endpoints */
func reportHandler(w http.ResponseWriter, r *http.Request) {
	switch r.Method {
	case "POST":
		// handle form data (post id, reply id, type, reason)
		// negative reply id can indicate that the report is for the post
	default:
		errorHandler(w, r, http.StatusBadRequest)
	}

}
