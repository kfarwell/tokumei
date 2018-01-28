/* Copyright (c) 2017-2018 Tokumei authors.
 * This software package is licensed for use under the ISC license.
 * See LICENSE for details.
 *
 * Tokumei is a simple, self-hosted microblogging platform. */

// This file contains only handlers for static pages.

package srv

import (
	"fmt"
	"log"
	"net/http"
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
