/* Copyright (c) 2017 Tokumei authors.
 * This software package is licensed for use under the ISC license.
 * See LICENSE for details.
 *
 * Tokumei is a simple, self-hosted microblogging platform. */

// Package posts contains functions pertaining to post and reply creation and
// management.
package posts

import (
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"os"
	"path/filepath"
	"strings"

	"gitlab.com/tokumei/tokumei/globals"
	"gitlab.com/tokumei/tokumei/timedate"
)

var (
	ErrPostNotFound       = errors.New("posts: id not found")
	ErrAttachmentNotFound = errors.New("posts: could not find valid attachment for post")
	ErrUnauthorized       = errors.New("posts: user not authorized to perform action")
	ErrBadRange           = errors.New("posts: range query is malformed")
)

// A Post is a parent to a slice of Reply and Report and is identified by Id,
// must have a Message string, may have option tags, and attachments.
// The only associated metadata is the number of times shared, and the (UTC)
// date posted.  A Post is a most interesting data structure in this package,
// and all else falls from it.
type Post struct {
	Id            int64    `json:"id"`
	Message       string   `json:"message"`
	Tags          []string `json:"tags"`
	TimesShared   int64    `json:"times_shared"`
	DatePosted    int64    `json:"date_posted"`
	Reports       []Report `json:"reports"`
	Replies       []Reply  `json:"replies"`
	AttachmentUri string   `json:"attachment_uri"` // TODO(krourke) change to array
	tempfilePath  string
	isFinal       bool
	delcode       string
}

// A Report is a simple way to contain data about objectionable user content.
// Some reasonable Types might "illegal content" or "spam". It is typically
// expected that a Reason also be provided so that Reports are not submitted on
// a whim.
type Report struct {
	Type   string `json:"type"`
	Reason string `json:"reason"`
}

func prettyJson(v interface{}) (string, error) {
	res, err := json.MarshalIndent(v, "", "  ")
	if err != nil {
		return "", err
	}
	return string(res), nil
}

// Post implements fmt.Stringer; it is printed as formatted JSON.
func (p Post) String() string {
	s, _ := prettyJson(p)
	return s
}

// IsValid() validates the integrity of a Post on some basic parameters. It may
// be useful to validate a post after it is retrieved from the database in the
// event that the database has been tampered with and invalid data is present.
func (p Post) IsValid() bool {
	if p.AttachmentUri != "" {
		// check attachment exists
		uri := strings.TrimPrefix(p.AttachmentUri, "/")
		if f, err := os.Stat(uri); os.IsNotExist(err) || f.IsDir() {
			return false
		}
	}
	// check no illegal values are in exported fields
	return p.Id >= 0 && p.Message != "" && p.TimesShared >= 0 && p.isFinal
}

// GetNumReports() returns the number of times a Post has been reported.
func (p Post) GetNumReports() int64 {
	return int64(len(p.Reports))
}

// GetNumReplies() returns the number of replies a Post has received.
func (p Post) GetNumReplies() int64 {
	return int64(len(p.Replies))
}

// PostSlice is a slice of Post which imposes ordering by Id.
type PostSlice []Post

// PostSlice implements sort.Interface
func (p PostSlice) Len() int           { return len(p) }
func (p PostSlice) Less(i, j int) bool { return p[i].Id < p[j].Id }
func (p PostSlice) Swap(i, j int)      { p[i], p[j] = p[j], p[i] }

// NewPost() creates a new Post without a valid Id. Finalize() must be called
// to assign an Id and create the expected directory structure for attachments.
// Returns nil on error. Code is a cleartext passphrase used to authenticate
// deletion; if code is an empty string, then it is not user-deletable.
func NewPost(message, filepath, code string, tags []string) *Post {
	if message == "" {
		return nil
	}

	date := timedate.UnixDateStamp(-1) // get current date at UTC 00:00

	// fix tags
	for i, v := range tags {
		tags[i] = strings.TrimSpace(v)
	}

	return &Post{
		Message:      message,
		DatePosted:   date,
		Tags:         tags,
		tempfilePath: filepath,
		isFinal:      false,
		delcode:      code,
	}
}

// Finalize() finalizes a new Post by assigning an Id, and processing the
// specified attachment, so that it may be inserted into the database.
// If a Post has already been finalized, then this function does nothing.
// TODO(krourke) do not preserve file names
// TODO(krourke) allow multiple attachments
func (p *Post) Finalize() (password string, err error) {
	if p.isFinal == true {
		return p.delcode, nil
	}

	// assign ID
	p.Id, err = GetPostNum()
	if err != nil && err != ErrPostNotFound {
		return "", err
	}
	p.Id += 1

	// check attachment file exists if present then move to public dir
	dir := fmt.Sprintf("%s/%d", globals.POSTDIR, p.Id)
	if p.tempfilePath != "" {
		if fstat, err := os.Stat(p.tempfilePath); os.IsNotExist(err) || !fstat.Mode().IsRegular() {
			return "", ErrAttachmentNotFound
		}
		src, err := os.Open(p.tempfilePath)
		if err != nil {
			return "", err
		}
		defer src.Close()
		// create destination file
		err = os.MkdirAll(filepath.FromSlash(dir), os.ModeDir)
		if err != nil {
			return "", err
		}
		attachment, err := os.Create(filepath.FromSlash(dir + "/" + filepath.Base(src.Name())))
		if err != nil {
			return "", err
		}
		// copy to dest
		if _, err := io.Copy(attachment, src); err != nil {
			return "", err
		}

		p.AttachmentUri = "/" + filepath.ToSlash(attachment.Name())
	}
	p.isFinal = true

	return p.delcode, nil
}

// InitDB() initializes the database with the correct schema for post and reply
// storage.
func InitDB(path string) error {
	return initDB(path)
}

// ReadPosts() retrieves all posts from the database, sorted by Post.Id.
func ReadPosts() ([]Post, error) {
	tx, err := db.Begin()
	if err != nil {
		return nil, err
	}
	posts, err := getAllPosts(tx)
	tx.Commit()

	return posts, err
}

// GetPostNum() retrieves the highest active Post ID from the database.
// The next Post's ID should always be this number plus one. Return value is
// negative if an error occurred. If there are no posts, then 0 is returned.
func GetPostNum() (int64, error) {
	tx, err := db.Begin()
	if err != nil {
		return -1, err
	}
	postnum, err := getPostNum(tx) // returns 0 on error
	tx.Commit()

	return postnum, err
}

// Lookup() retreives a Post from the database.
// The returned Post is nil if no Post exists with the specified id.
func Lookup(id int64) (*Post, error) {
	tx, err := db.Begin()
	if err != nil {
		return nil, err
	}
	p, err := getPost(tx, id)
	tx.Commit()
	return p, err
}

// GetPostsRange() returns a PostSlice of existing indexed posts. The parameters
// l and h specify the lowest and highest post *indices* to slice the posts.
// If either l or h are negative, then the search is unbounded on the lower or
// higher bounds respectively. If l and h are equal, then only one post
// is returned. If l is higher than the number of posts available, a nil slice
// is returned. If h is higher than the number of posts available, the higher
// bound is made to be unbounded. If l > h >= 0, then the nil slice is returned
// because this range is nonsensical.
//
// It is important to note that l and h are *not* post IDs. They are bounds on a
// range of values to be returned. Ex. if there are 500 posts in the database,
// and you want to get the second set of 20 posts, then query with l=20, h=41.
//
// If the intention is to return a single post, and you know the post ID, then
// the Lookup function should be used instead.
//
// TODO(krourke) fix range to be inclusive (l, h)
func GetPostsRange(l, h int) []Post {
	posts, err := ReadPosts()
	if err != nil {
		return nil
	}

	// parse request
	if l > len(posts) {
		return nil
	}
	if h >= len(posts) { // too high of a bound is treated as no bound
		h = -1
	}
	if 0 <= h && h < l { // bad range is 0 <= h <= l
		//fmt.Println("0 <= h < 1")
		return nil
	} else if l <= 0 && h >= 0 { // no lower bound
		//fmt.Println("no lower")
		return posts[:h]
	} else if l >= 0 && h <= 0 { // no upper bound
		//fmt.Println("no upper")
		return posts[l:]
	} else if h > l && l >= 0 || (l >= 0 && h == l) { // fetch between l and h inclusive
		//fmt.Println("l - h")
		return posts[l : h+1]
	}
	// else return all posts if both parameters are negative
	return posts
}

// AddPost() adds a Post to the database with optional deletion code. code
// should be passed in cleartext as it is hashed in this function if it's
// provided. Posts without delete codes are not user-deletable.
func AddPost(p *Post, code string) error {
	if p == nil {
		return errors.New("posts: cannot add nil post")
	} else if p.Id < 0 || p.Message == "" {
		return errors.New("posts: cannot add malformed post")
	}
	tx, err := db.Begin()
	if err != nil {
		return err
	}
	if err = addPost(tx, p); err != nil {
		return err
	}
	if code == "" { // if no delcode to add
		return tx.Commit()
	}
	// add a delete code if one was specified on post creation
	if err = addDelCode(tx, NewDeleteCode(p.Id, -1, code)); err != nil {
		return err
	}
	return tx.Commit()
}

// ForceDelete() deletes a Post specified by id and all associated replies,
// reports, etc. This function does not respect user-specified deletion codes.
func ForceDelete(id int64) error {
	tx, err := db.Begin()
	if err != nil {
		return err
	}
	if err = removePost(tx, id); err != nil {
		return err
	}
	return tx.Commit()
}

// Delete() attempts to delete a Post specified by id. If Post is protected byr
// a deletion code, it should be passed in cleartext as the code parameter.
// The code parameter may not be an empty string. If a Post does not have a
// deletion code associated with it, ErrUnauthorized is returned.
func Delete(id int64, code string) error {
	tx, err := db.Begin()
	if err != nil {
		return err
	}
	err = deletePost(tx, id, code)
	tx.Commit()
	return err
}
