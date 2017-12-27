/* Copyright (c) 2017 Tokumei authors.
 * This software package is licensed for use under the ISC license.
 * See LICENSE for details.
 *
 * Tokumei is a simple, self-hosted microblogging platform. */

// Subcommand admin is used to administrate a Tokumei server.
// Definitions for commands for the admin command line interface are located in
// this packae and serve as a reference for future admin web consoles.
package admin

import (
	"fmt"
	"os"
	"strconv"

	// imports as "cli", pinned to v1; cliv2 is going to be drastically
	// different and pinning to v1 avoids issues with unstable API changes
	"gopkg.in/urfave/cli.v1"
)

// Cmds is a set of verbose, semi-interactive administrative commands.
//
// TODO(krourke) fix 'admin stat' command.
var Cmds = []cli.Command{
	// remove a post
	cli.Command{
		Name:    "remove",
		Aliases: []string{"rm"},
		Usage:   "remove a post by the specified post-id",
		Action: func(cx *cli.Context) {
			if cx.NArg() < 1 {
				fmt.Println("rm: post number required")
				os.Exit(2)
			} else if cx.NArg() > 1 {
				fmt.Println("rm: too many arguments")
				os.Exit(2)
			}

			if n, err := strconv.ParseInt(cx.Args().Get(0), 10, 64); err == nil {
				if err = removePost(n); err != nil {
					fmt.Println(err)
					os.Exit(1)
				} else {
					os.Exit(0)
				}
			} else {
				fmt.Println("rm: post num must be an integer")
				os.Exit(2)
			}
		},
	},
	// get post statistics
	cli.Command{
		Name:  "stat",
		Usage: "get statistics on a post specified by ID",
		Flags: []cli.Flag{
			cli.BoolFlag{
				Name:  "with-replies",
				Usage: "show replies to post",
			},
			cli.BoolFlag{
				Name:  "with-reports",
				Usage: "show reports on a post",
			},
			cli.Int64Flag{
				Name:  "reply",
				Usage: "view a reply by the specified id",
			},
		},
		Action: func(cx *cli.Context) {
			if cx.NArg() < 1 {
				fmt.Println("stat: post number required")
				os.Exit(2)
			} else if cx.NArg() > 3 {
				fmt.Println("stat: too many arguments")
				os.Exit(2)
				//	} else if cx.Bool("with-replies") && strings.Contains(strings.Join(cx.FlagNames(), " "), "reply") {
				//		fmt.Println("stat: cannot use --with-replies and --reply flags together")
				//		os.Exit(2)
			}

			if n, err := strconv.ParseInt(cx.Args().Get(0), 10, 64); err == nil {
				//				if strings.Contains(strings.Join(cx.FlagNames(), " "), "reply") {
				//					if err = statReply(n, cx.Int64("reply"), cx.Bool("with-reports")); err != nil {
				//						fmt.Println(err)
				//						os.Exit(1)
				//					}
				//				} else {
				if err = statPost(n, cx.Bool("with-reports"), cx.Bool("with-replies")); err != nil {
					fmt.Println(err)
					os.Exit(1)
				}
				//				}
				os.Exit(0)
			} else {
				fmt.Println("stat: post num must be an integer")
				os.Exit(2)
			}
		},
	},
	// make a post
	cli.Command{
		Name:  "post",
		Usage: "make a post on this tokumei instance",
		Action: func(cx *cli.Context) {
			if cx.NArg() > 0 {
				fmt.Println("post: does not take arguments")
				os.Exit(2)
			}
			if err := sendPost(); err != nil {
				fmt.Println(err)
				os.Exit(1)
			}
			os.Exit(0)
		},
	},
}
