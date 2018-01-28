/* Copyright (c) 2017-2018 Tokumei authors.
 * This software package is licensed for use under the ISC license.
 * See LICENSE for details.
 *
 * Tokumei is a simple, self-hosted microblogging platform. */

package srv

import (
	"fmt"
	"html/template"
	"log"
	"strings"

	"gitlab.com/tokumei/tokumei/globals"
	"gitlab.com/tokumei/tokumei/timedate"
)

var (
	Templates     []*template.Template
	TplCollection *template.Template

	/* useful additional functions to for templating:
	 * use as `{{.Entity | func args...}}`
	 */
	tmplFuncs = template.FuncMap{
		// upper case text in template
		"upper": func(s string) string {
			return strings.ToUpper(s)
		},
		// lower case text in template
		"lower": func(s string) string {
			return strings.ToLower(s)
		},
		// make file sizes human readable
		"humanize": func(n uint64) string {
			sizes := []string{"KB", "MB", "GB"}
			hs := sizes[0]
			for i := 0; n > 1024 && i < len(sizes); i++ {
				n /= 1024
				hs = sizes[i]
			}
			return fmt.Sprintf("%d %s", n, hs)
		},
		"date": func(sec int64) string {
			return timedate.ParseUnixDate(sec)
		},
	}
)

func CacheTemplates() error {
	TplCollection = template.New("t")
	TplCollection = TplCollection.Funcs(tmplFuncs)
	TplCollection, err := TplCollection.ParseGlob(globals.TMPLDIR + "/*.html")
	if err != nil {
		return err
	}
	Templates = TplCollection.Templates()
	if Verbose {
		log.Println("loaded templates.")
	}
	return nil
}
