package admin

import (
	"bufio"
	"errors"
	"fmt"
	"os"
	"strings"

	"gitlab.com/tokumei/tokumei/posts"
	"gitlab.com/tokumei/tokumei/srv"
)

// This function provides a simple interactive console to make a post.
// This is run from the admin interface on the localhost's server, so no
// authentication via captcha or API keys is required.
func sendPost() error {
	var msg, tagstr, file string

	sc := bufio.NewScanner(os.Stdin)

	fmt.Println("Enter message (end with two blank lines):")
	var lastline string
	for sc.Scan() {
		line := sc.Text()
		if line == "" && lastline == "" {
			break
		}
		msg += line
		lastline = line
	}
	msg = strings.TrimSpace(msg)
	fmt.Println("Enter comma separated tags:")
	sc.Scan()
	tagstr = sc.Text()
	fmt.Println("Enter path to attachment:")
	sc.Scan()
	file = sc.Text()

	if file != "" {
		if fstat, err := os.Stat(file); os.IsNotExist(err) || !fstat.Mode().IsRegular() {
			fmt.Println("could not stat file.")
			return posts.ErrAttachmentNotFound
		}
	}

	p := posts.NewPost(msg, file, "", strings.Split(tagstr, ","))
	if p == nil {
		return errors.New("admin sendpost: post is malformed")
	}

	go srv.QueuePost(p)
	fmt.Println("Posted.")

	return nil
}
