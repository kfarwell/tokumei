/* Copyright (c) 2017-2018 Tokumei authors.
 * This software package is licensed for use under the ISC license.
 * See LICENSE for details.
 *
 * Tokumei is a simple, self-hosted microblogging platform. */

// Command tokumei runs a simple, anonymous, self-hosted microblogging service.
// Get started with Tokumei by heading over to https://tokumei.co/hosting and
// following our simple guide. While this package is go-gettable, unless you are
// hacking on Tokumei, it is recommended that you use our installation scripts.
//
// Commands
//
// Tokumei comes with a simple CLI which is defined in this package.
// Once you've installed and configured Tokumei, simply run:
//	./tokumei start &        # to start a web server listening on port :1337
//	./tokumei admin --help   # view administrative commands
// That's all there is to it :)
package main

import (
	"fmt"
	"log"
	"os"

	// imports as "cli", pinned to v1; cliv2 is going to be drastically
	// different and pinning to v1 avoids issues with unstable API changes
	"gopkg.in/urfave/cli.v1"

	"gitlab.com/tokumei/tokumei/cmd/admin"
	"gitlab.com/tokumei/tokumei/globals"
	"gitlab.com/tokumei/tokumei/posts"
	"gitlab.com/tokumei/tokumei/srv"
)

var (
	// admin console inferface
	// see admin_cmds.go for subcommands and flags
	Admin = cli.Command{
		Name:        "admin",
		Usage:       "perform administrative tasks",
		Subcommands: admin.Cmds,
	}

	// server start
	Start = cli.Command{
		Name:    "start",
		Aliases: []string{"run"},
		Usage:   "start the Tokumei server",
		Flags: []cli.Flag{
			cli.StringFlag{
				Name:        "port, p",
				Value:       "3003",
				Usage:       "set `PORT` for the server at run-time",
				Destination: &srv.Port,
			},
			cli.StringFlag{
				Name:  "config, c",
				Value: "cfg/config.json",
				Usage: "load configuration at run-time from `FILE`",
			},
			cli.BoolFlag{
				Name:  "diagnose, d",
				Usage: "print server configuration before start",
			},
			cli.BoolFlag{
				Name:  "verbose, v",
				Usage: "set verbose output",
			},
		},
		Action: func(cx *cli.Context) {
			// set config file
			if cx.IsSet("config") {
				c := cx.String("config")
				if f, err := os.Stat(c); !os.IsNotExist(err) && f.Mode().IsRegular() {
					srv.CFGFILE = c
				} else {
					fmt.Printf("Could not open specified config file: %s\n", c)
					os.Exit(1)
				}
			}
			// print settings as loaded from the config file
			if cx.Bool("diagnose") {
				fmt.Println("Using server config file at: " + srv.CFGFILE)
				fmt.Println("Settings as read from file:")
				fmt.Print(srv.Conf.String())
				fmt.Println()
			}
			// set verbosity of server logging
			if cx.Bool("verbose") {
				srv.Verbose = true
			}
			srv.StartServer(srv.Port)
		},
	}
)

func init() {
	// read the server configuration file into memory
	if err := srv.Conf.ReadConfig(srv.CFGFILE); err != nil {
		log.Fatalf("config error: %s\n", err)
	}
	if err := srv.Conf.ValidateConfig(); err != nil {
		log.Fatalf("config error: %s\n", err)
	}
	srv.Port = string(srv.Conf.Port)

	// logging configuration
	if os.Getenv("TOKUMEI_ENV") == "DEV" {
		log.SetPrefix("tokumei: ")
		log.SetFlags(log.Lshortfile) // print file line num with log entry
		log.SetOutput(os.Stdout)
		srv.Verbose = true
	}

	// bootstrap the application's post database
	if err := posts.InitDB(globals.POSTDB); err != nil {
		log.Fatal(err)
	}
}

func main() {
	// customize cli
	cli.VersionPrinter = func(c *cli.Context) {
		fmt.Fprintf(c.App.Writer, "%s %s - %s\n",
			c.App.Name, c.App.Version, c.App.Description)
	}

	// set up the application with man-page description
	app := cli.NewApp()
	app.Authors = []cli.Author{
		cli.Author{
			Name:  "Keefer Rourke",
			Email: "mail@krourke.org",
		},
	}
	app.Copyright = "(c) 2015-18 Tokumei distributed under the ISC license\n"
	app.EnableBashCompletion = false // harmful
	app.Name = "Tokumei"
	app.Description = "A simple, self-hosted microblogging platform"
	app.Usage = "run a Tokumei server"
	app.Version = globals.VERSION
	app.Commands = []cli.Command{
		Admin,
		Start,
	}
	app.CommandNotFound = func(c *cli.Context, command string) {
		fmt.Fprintf(c.App.Writer, "Did you read the manual? %s isn't in it.\n", command)
	}

	// run Tokumei
	app.Run(os.Args)
}
