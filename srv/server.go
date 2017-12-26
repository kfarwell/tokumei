/* Copyright (c) 2017 Tokumei authors.
 * This software package is licensed for use under the ISC license.
 * See LICENSE for details.
 *
 * Tokumei is a simple, self-hosted microblogging platform. */

// Package srv contains functions pertaining to Tokumei server operations.
package srv

import (
	/* Standard library packages */
	"fmt"
	"log"
	"net/http"
	/* Tokumei */ // other settings are stored in the Conf object belonging to this package
)

// Routes is a map of string to base request paths. Packages that wish to extend
// the functionality of a Tokumei server may add new routes and handlers in the
// form of
//	srv.Routes["custom_page"] = "/path/to/custom/page"
//	...
//	http.HandleFunc(Routes["custom_page"], func(w http.ResponseWriter, r *http.Request){
//		// custom page handler
//	})
// If the page needs to be rendered, place a Go html/template formatted html
// file in the public/html directory. Tokumei will panic if the template fails
// to execute properly. See other templates in that directory for reference.
//
// Predefined routes are as follows, you probably don't want to overwrite them:
//	Routes["index"] = "/"                                 // the landing page
//	Routes["about"] = "/about"                            // the about page
//	Routes["apidoc"] = "/api"                             // API documentation
//	Routes["donate"] = "/donate"                          // donation page; enabled/disabled in cfg/config.json
//	Routes["privacy"] = "/privacy"                        // privacy policies
//	Routes["rules"] = "/rules"                            // rules of this tokumei instance
//	Routes["search"] = "/search"                          // site-wide search; enabled/disabled in cfg/config.json
//	Routes["settings"] = "/settings"                      // user preferences; enabled/disabled in cfg/config.json
//	Routes["allposts"] = "/posts"                         // JSON API endpoint to fetch posts
//	Routes["postnum"] = "/postnum"                        // API endpoint to retrieve most recent post ID
//	Routes["report"] = "/report"                          // post report destination
//	Routes["post"] = "/p/"                                // the main post handler
//	Routes["timeline"] = Routes["posts"] + "timeline"     // the timeline feed
//	Routes["trending"] = Routes["posts"] + "/trending"    // the trending feed
//	Routes["following"] = Routes["posts"] + "/following"  // the following feed
var Routes map[string]string

func init() {
	// define routes
	Routes = make(map[string]string)
	Routes["index"] = "/"
	Routes["about"] = "/about"
	Routes["apidoc"] = "/api"
	Routes["donate"] = "/donate"
	Routes["privacy"] = "/privacy"
	Routes["rules"] = "/rules"
	Routes["search"] = "/search"
	Routes["settings"] = "/settings"

	Routes["allposts"] = "/posts"
	Routes["postnum"] = "/postnum"
	Routes["report"] = "/report"
	Routes["post"] = "/p/"
	Routes["timeline"] = Routes["posts"] + "timeline"
	Routes["trending"] = Routes["posts"] + "/trending"
	Routes["following"] = Routes["posts"] + "/following"

	// cache templates
	if err := CacheTemplates(); err != nil {
		log.Fatal(err)
	}

	// start "daemons"
	go listenForPosts()
	go listenForReplies()
	go listenForReports()
}

// Any custom configs or port numbers specified at run time are automatically
// stored in globals.CFGPATH and globals.PORT before this function starts.
// StartServer always uses the correct settings
func StartServer(port string) {
	fmt.Println("Server is running on port: " + port)

	/* static file servers */
	http.Handle("/css/", http.StripPrefix("/css/", http.FileServer(http.Dir("public/css"))))
	http.Handle("/fonts/", http.StripPrefix("/fonts/", http.FileServer(http.Dir("public/fonts"))))
	http.Handle("/img/", http.StripPrefix("/img/", http.FileServer(http.Dir("public/img"))))
	http.Handle("/js/", http.StripPrefix("/js/", http.FileServer(http.Dir("public/js"))))
	http.Handle("/files/", http.StripPrefix("/files/", http.FileServer(http.Dir("public/files"))))

	/* route handlers */
	// static pages
	http.HandleFunc(Routes["index"], indexHandler)
	http.HandleFunc(Routes["about"], aboutHandler)
	http.HandleFunc(Routes["apidoc"], apiDocHandler)
	http.HandleFunc(Routes["donate"], donateHandler)
	http.HandleFunc(Routes["privacy"], privacyHandler)
	http.HandleFunc(Routes["rules"], rulesHandler)
	// dynamic pages
	http.HandleFunc(Routes["post"], postHandler)
	http.HandleFunc(Routes["timeline"], timelineHandler)
	http.HandleFunc(Routes["trending"], trendingHandler)
	http.HandleFunc(Routes["following"], followingHandler)
	// get api only
	http.HandleFunc(Routes["allposts"], getPostsHandler)
	http.HandleFunc(Routes["postnum"], getPostNumHandler)
	// post api only
	http.HandleFunc(Routes["report"], reportHandler)

	// listen and server forever
	log.Fatal(http.ListenAndServe(":"+port, nil))
}
