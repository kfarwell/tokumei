package admin

import (
	"errors"
	"fmt"
	"strings"

	"gitlab.com/tokumei/tokumei/posts"
	"gitlab.com/tokumei/tokumei/timedate"
)

// This function prints Post info and stats about replies and reports.
func statPost(id int64, withReports, withReplies bool) error {
	p, err := posts.Lookup(id)
	if p == nil {
		return posts.ErrPostNotFound
	} else if err != nil {
		return err
	}

	fmt.Printf("Post %d (shared %d times):\n", p.Id, p.TimesShared)
	fmt.Printf("Posted on %s\n", timedate.ParseUnixDate(p.DatePosted))
	fmt.Printf("\"%s\"\n", p.Message)
	fmt.Printf("tags: %s\n", strings.Join(p.Tags, ", "))
	fmt.Printf("replies: %d\n", p.GetNumReplies())
	fmt.Printf("reports: %d\n", p.GetNumReports())

	if withReports {
		for i, v := range p.Reports {
			fmt.Printf("Report %d:\n", i)
			fmt.Printf("Type: %s\n", v.Type)
			fmt.Printf("Reason: %s\n", v.Reason)
			fmt.Println()
		}
	}
	if withReplies {
		for _, v := range p.Replies {
			fmt.Printf("Reply (ID %d):\n", v.Id)
			fmt.Printf("Posted on %s\n", timedate.ParseUnixDate(v.DatePosted))
			fmt.Printf("\"%s\"\n", v.Message)
			fmt.Printf("reports: %d\n", v.GetNumReports())
			fmt.Println()
		}
	}

	return nil
}

func statReply(postId, replyNum int64, withReports bool) error {
	p, err := posts.Lookup(postId)
	if p == nil {
		return posts.ErrPostNotFound
	} else if err != nil {
		return err
	}

	found := false
	for _, v := range p.Replies {
		if v.Id == replyNum {
			fmt.Printf("Reply (ID %d) to Post (ID %d):\n", v.Id, p.Id)
			fmt.Printf("Posted on %s\n", timedate.ParseUnixDate(v.DatePosted))
			fmt.Printf("\"%s\"\n", v.Message)
			fmt.Printf("reports: %d\n", v.GetNumReports())
			fmt.Println()

			if withReports {
				for i, w := range v.Reports {
					fmt.Printf("Report %d:\n", i)
					fmt.Printf("Type: %s\n", w.Type)
					fmt.Printf("Reason: %s\n", w.Reason)
					fmt.Println()
				}
			}
			found = true
			break
		}
	}
	if found != true {
		return errors.New("admin stat: could not find reply with specified id")
	}
	return nil
}
