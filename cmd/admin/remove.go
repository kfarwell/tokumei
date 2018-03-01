/* Copyright (c) 2017-2018 Tokumei authors.
 * This software package is licensed for use under the ISC license.
 * See LICENSE for details.
 *
 * Tokumei is a simple, self-hosted microblogging platform. */

package admin

import (
	"errors"
	"fmt"
	"strings"

	"gitlab.com/tokumei/tokumei/posts"
)

// This is a verbose function that is part of the admin console interface.
// It attempts to remove a post by the specified id.
func removePost(id int64) error {
	if id < 0 {
		return errors.New("admin rm: invalid post id specified")
	}
	p, err := posts.Lookup(id)
	if err != nil {
		return err
	} else if p == nil {
		return posts.ErrPostNotFound
	}

	fmt.Printf("Found post: %s\n", p.String())

	var yn string
	fmt.Print("Are you sure you want to remove post? [y/N] ")
	fmt.Scanln(&yn)
	switch strings.ToLower(yn) {
	case "yes":
		fallthrough
	case "y":
		// just need the confirmation to continue
	default:
		fmt.Println("Aborted.")
		return nil
	}

	return posts.ForceDelete(p.Id)
}
