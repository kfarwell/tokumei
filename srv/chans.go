/* Copyright (c) 2017 Tokumei authors.
 * This software package is licensed for use under the ISC license.
 * See LICENSE for details.
 *
 * Tokumei is a simple, self-hosted microblogging platform. */

package srv

import (
	"fmt"
	"log"

	"gitlab.com/tokumei/tokumei/posts"
)

// TODO(krourke)
var (
	deleteChan = make(chan *posts.DeleteCode)
	postChan   = make(chan *posts.Post)
	reportChan = make(chan *posts.Report)
	replyChan  = make(chan *posts.Reply)
)

func QueueDeleteCode(d *posts.DeleteCode) {
	if d != nil {
		deleteChan <- d
	}
}

// QueuePost() queues a newly created Post to be added to the server database.
func QueuePost(p *posts.Post) {
	if p != nil {
		postChan <- p
	}
}

// QueueReply() queues a newly created Reply to be added to the server database.
// If r was not created via posts.NewReply() it is silently discarded later.
func QueueReply(r *posts.Reply) {
	if r != nil {
		replyChan <- r
	}
}

// QueueReport() queues a newly created Report to be added to the server
// database. If r was not created via posts.NewReport() it is silently discarded
// later.
func QueueReport(r *posts.Report) {
	if r != nil {
		reportChan <- r
	}
}

// run as a go-routine
func listenForDeleteCodes() {
	for {
		<-deleteChan
	}
}

// run as a go-routine
func listenForPosts() {
	for {
		p := <-postChan
		if p != nil {
			fmt.Print("got post:", p)
			delcode, err := p.Finalize()
			if err != nil {
				continue
			}
			err = posts.AddPost(p, delcode)
			if err != nil {
				log.Println(err)
			}
		}
	}
}

// run as a go-routine
func listenForReports() {
	for {
		<-reportChan
	}
}

// run as a go-routine
func listenForReplies() {
	for {
		<-replyChan
	}
}
