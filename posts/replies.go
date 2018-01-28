/* Copyright (c) 2017-2018 Tokumei authors.
 * This software package is licensed for use under the ISC license.
 * See LICENSE for details.
 *
 * Tokumei is a simple, self-hosted microblogging platform. */

package posts

import (
	"gitlab.com/tokumei/tokumei/timedate"
)

// A Reply is a simple struct containing an Id, a Message and the (UTC) date it
// was posted. Reports on a Reply are handled much in the same way that they are
// handled for a Post.
type Reply struct {
	Id         int64    `json:"id"`
	Message    string   `json:"message"`
	DatePosted int64    `json:"date_posted"`
	Reports    []Report `json:"reports"`
	parentId   int64
	isFinal    bool
	delcode    string
}

// Reply implements fmt.Stringer; it is printed as formatted JSON.
func (r Reply) String() string {
	s, _ := prettyJson(r)
	return s
}

// It may be useful to validate a reply after it has been retreived from the
// database in the event that the database has been tampered with and invalid
// data is present.
func (r Reply) IsValid() bool {
	return r.Id >= 0 && r.Message != "" && r.isFinal
}

// GetNumReports() returns the number of times a Reply has been reported.
func (r Reply) GetNumReports() int64 {
	return int64(len(r.Reports))
}

// ReplySlice is a slice of Reply which imposes ordering by Id
type ReplySlice []Reply

// ReplySlice implements sort.Interface
func (r ReplySlice) Len() int           { return len(r) }
func (r ReplySlice) Less(i, j int) bool { return r[i].Id < r[j].Id }
func (r ReplySlice) Swap(i, j int)      { r[i], r[j] = r[j], r[i] }

// NewReply() creates a new Reply without a valid Id. Finalize() must be called
// to assign a reply number (Reply.Id).
func NewReply(parent int64, code, comment string) *Reply {
	if parent <= 0 {
		return nil
	}

	date := timedate.UnixDateStamp(-1) // get current date at UTC 00:00

	return &Reply{
		Message:    comment,
		DatePosted: date,
		parentId:   parent,
		isFinal:    false,
		delcode:    code,
	}
}

// Finalize() finalizes a new Post by assigning an Id to the Reply so that it
// may be inserted into the database. If a Reply has already been finalized,
// then this function does nothing.
func (r *Reply) Finalize() (password string, err error) {
	if r.isFinal == true {
		return r.delcode, nil
	}

	// assign reply ID
	r.Id, err = GetReplyNum(r.parentId)
	if err != nil && err != ErrPostNotFound {
		return "", err
	}
	r.Id += 1

	r.isFinal = true
	return r.delcode, nil
}

// GetReplyNum() retrieves the highest active Reply ID for a particular post
// from the database. The next Reply ID should always be this number plus one.
// Return value is negative if an error occurred. If there are no replies, then
// 0 is returned.
func GetReplyNum(parentID int64) (int64, error) {
	tx, err := db.Begin()
	if err != nil {
		return -1, err
	}
	replynum, err := getReplyNum(tx, parentID) // returns 0 on error
	tx.Commit()
	return replynum, err
}

// AddReply() adds a reply to a post by the postId. As with AddPost(), code is
// an optional cleartext deletion code; pass an empty string to omit the delete
// code and prevent reply-deletion by users.
func AddReply(postId int64, r *Reply, code string) error {
	tx, err := db.Begin()
	if err != nil {
		return err
	}
	if err := addReply(tx, postId, r); err != nil {
		return err
	}
	if code == "" { // if no delcode to add
		return tx.Commit()
	}
	// add the code to the database
	if err = addDelCode(tx, NewDeleteCode(r.Id, r.parentId, code)); err != nil {
		return err
	}
	return tx.Commit()
}
