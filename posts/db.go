/* Copyright (c) 2017 Tokumei authors.
 * This software package is licensed for use under the ISC license.
 * See LICENSE for details.
 *
 * Tokumei is a simple, self-hosted microblogging platform. */

// db.go contains the unexported backend interactions with the database
// exported functionality should wrap these functions

package posts

import (
	"database/sql"
	"errors"
	"sort"
	"strings"

	_ "github.com/mattn/go-sqlite3" // sql driver
	"gitlab.com/tokumei/tokumei/timedate"
	"golang.org/x/crypto/bcrypt"
)

var db *sql.DB

// The table names that are used internally in the Sqlite3 database. It may be
// be helpful at times to open a Sqlite shell and inspect these tables to aid
// in debugging and/or server administration.
const (
	POST_TABLE      string = "posts"
	REPLY_TABLE     string = "replies"
	P_REPORT_TABLE  string = "post_reports"
	R_REPORT_TABLE  string = "reply_reports"
	P_DELCODE_TABLE string = "post_del_codes"
	R_DELCODE_TABLE string = "reply_del_codes"
)

func initDB(path string) error {
	var err error
	if db, err = sql.Open("sqlite3", "file:"+path+"?foreign_keys=on"); err != nil {
		return err
	}

	stmts := []string{
		`pragma foreign_keys = on;`,
		// create posts table; id is a non-negative post id - a Post struct is
		// inserted into this table pretty much verbatim
		`create table if not exists ` + POST_TABLE + `(
            id             integer primary key not null,
            message        text not null,
            tags           text not null,
            times_shared   integer not null,
            date           integer not null,
            attachment_uri text not null
        );`,
		// create replies table; id is a dumb identifier to associate reports
		// and delcodes and is not exported anywhere
		`create table if not exists ` + REPLY_TABLE + `(
            id        integer primary key not null,
            parent    integer not null,
            reply_num integer not null,
            message   text not null,
            foreign key (parent) references ` + POST_TABLE + `(id)
        );`,
		// create reports table for posts
		`create table if not exists ` + P_REPORT_TABLE + `(
            id     integer primary key not null,
            type   text not null,
            reason text not null,
            foreign key (id) references ` + POST_TABLE + `(id)
        );`,
		// create reports table for replies
		`create table if not exists ` + R_REPORT_TABLE + `(
            id     integer primary key not null,
            type   text not null,
            reason text not null,
            foreign key (id) references ` + REPLY_TABLE + `(id)
        );`,
		// create delcodes table for posts
		`create table if not exists ` + P_DELCODE_TABLE + `(
            id   integer primary key not null,
            hash text not null,
            salt text not null,
            foreign key (id) references ` + POST_TABLE + `(id)
        );`,
		// create delcodes table for replies
		`create table if not exists ` + R_DELCODE_TABLE + `(
            id   integer primary key not null,
            hash text not null,
            salt text not null,
            foreign key (id) references ` + REPLY_TABLE + `(id)
        );`,
	}

	for _, s := range stmts {
		_, err = db.Exec(s)
		if err != nil {
			return err
		}
	}
	return nil
}

// beyond basic validation for a non-negative post-ID and non-empty message, no
// other safety exists in this unexported function; it is expected that the
// caller properly validates and escapes input
func addPost(tx *sql.Tx, p *Post) error {
	if p == nil {
		return errors.New("posts/db: cannot add nil post")
	} else if p.Id < 0 || p.Message == "" {
		return errors.New("posts/db: cannot add post without valid id or message")
	}

	ins, err := tx.Prepare("insert or ignore into " + POST_TABLE + " (id, message, tags, times_shared, date, attachment_uri) values (?, ?, ?, ?, ?, ?)")
	if err != nil {
		return nil
	}
	defer ins.Close()

	tags := strings.Join(p.Tags, ",")
	attachments := strings.Join(p.AttachmentUri, ",")
	datestamp := timedate.UnixDateStamp(p.DatePosted)
	_, err = ins.Exec(p.Id, p.Message, tags, p.TimesShared, datestamp, attachments)
	return err
}

// add a Report to the Post specified by id
func addReport(tx *sql.Tx, id int64, r *Report) error {
	if r == nil {
		return errors.New("posts/db: cannot add nil report")
	} else if id < 0 || r.Type == "" {
		return errors.New("posts/db: cannot add report without valid id or message")
	}

	ins, err := tx.Prepare("insert or ignore into " + P_REPORT_TABLE + " (id, type, reason) values (?, ?, ?)")
	if err != nil {
		return nil
	}
	defer ins.Close()
	if _, err := ins.Exec(id, r.Type, r.Reason); err != nil {
		return err
	}
	return nil
}

// add a deletion code to the database
func addDelCode(tx *sql.Tx, d *DeleteCode) error {
	if d == nil {
		return errors.New("posts/db: cannot add nil delcode")
	}
	var ins *sql.Stmt
	var err error
	if d.Parent < 0 { // if for top-level post
		ins, err = tx.Prepare("insert or ignore into " + P_DELCODE_TABLE + " (id, hash, salt) values (?, ?, ?)")
	} else { // else if for a post reply
		ins, err = tx.Prepare("insert or ignore into " + R_DELCODE_TABLE + " (id, hash, salt) values (?, ?, ?)")
	}
	if err != nil {
		return nil
	}
	defer ins.Close()

	_, err = ins.Exec(d.Id, d.Hash, d.Salt)
	return err
}

// adds a Reply to the Post specified by postId
func addReply(tx *sql.Tx, postId int64, r *Reply) error {
	if r == nil {
		return errors.New("posts/db: cannot add nil reply")
	} else if postId < 0 || r.Message == "" {
		return errors.New("posts/db: cannot add reply without valid id or message")
	}
	ins, err := tx.Prepare("insert or ignore into " + REPLY_TABLE + " (parent, reply_num, message) values (?, ?, ?)")
	if err != nil {
		return nil
	}
	defer ins.Close()

	_, err = ins.Exec(postId, r.Id, r.Message)
	return err
}

// adds a report to a specified reply
func addReplyReport(tx *sql.Tx, r *Reply, v *Report) error {
	if r == nil {
		return errors.New("posts/db: cannot add reports to nil reply")
	} else if r.Id < 0 || r.Message == "" {
		return errors.New("posts/db: cannot use invalid reply")
	}

	ins, err := tx.Prepare("insert or ignore into " + R_REPORT_TABLE + " (id, type, reason) values (?, ?, ?")
	if err != nil {
		return nil
	}
	defer ins.Close()

	if _, err := ins.Exec(r.Id, v.Type, v.Reason); err != nil {
		return err
	}
	return nil
}

// retrieves the highest active Post.Id
func getPostNum(tx *sql.Tx) (int64, error) {
	row := tx.QueryRow("select max(id) from " + POST_TABLE)
	var postnum int64
	if err := row.Scan(&postnum); err == sql.ErrNoRows {
		return 0, ErrPostNotFound
	} else if err != nil {
		return -1, err
	}
	return postnum, nil
}

// retrieves the highest active Reply.Id for a given Post
func getReplyNum(tx *sql.Tx, parent int64) (int64, error) {
	p, err := Lookup(parent)
	if p == nil {
		return -1, ErrPostNotFound
	} else if err != nil {
		return -1, err
	}
	row := tx.QueryRow("select max(reply_num) from " + REPLY_TABLE)
	var replynum int64
	if err := row.Scan(&replynum); err == sql.ErrNoRows {
		return 0, nil
	} else if err != nil {
		return -1, err
	}
	return replynum, nil
}

// retrieves all Posts in the database, sorted by id
func getAllPosts(tx *sql.Tx) ([]Post, error) {
	rows, err := tx.Query("select id from " + POST_TABLE)
	if err == sql.ErrNoRows {
		return nil, nil
	} else if err != nil {
		return nil, err
	}

	var posts []Post

	for rows.Next() {
		var id int64
		if err := rows.Scan(&id); err != nil {
			return nil, err
		}
		if p, err := getPost(tx, id); err != nil {
			return nil, err
		} else if p.IsValid() { // only append valid db entries
			posts = append(posts, *p)
		}
	}
	sort.Sort(PostSlice(posts))
	return posts, nil
}

// retreives a reference to a fully qualified Post
func getPost(tx *sql.Tx, id int64) (*Post, error) {
	var postId int64
	var message, rawTags, attachmentUri string
	var timesShared, date int64

	// get post with id
	row := tx.QueryRow("select * from "+POST_TABLE+" where id = ?", id)
	if err := row.Scan(&postId, &message, &rawTags, &timesShared, &date, &attachmentUri); err == sql.ErrNoRows {
		return nil, ErrPostNotFound
	} else if err != nil {
		return nil, err
	}

	// get all reports
	var reports []Report
	rows, err := tx.Query("select type, reason from "+P_REPORT_TABLE+" where id = ?", postId)
	if err == sql.ErrNoRows {
		reports = nil
	} else if err != nil {
		return nil, err
	}
	for rows.Next() {
		var typ, reason string
		if err := rows.Scan(&typ, &reason); err != nil {
			return nil, err
		}
		reports = append(reports, Report{
			Type:   typ,
			Reason: reason,
		})
	}
	rows.Close()

	// get all replies
	var replies []Reply
	rows, err = tx.Query("select id, reply_num, message from "+REPLY_TABLE+" where parent = ?", postId)
	if err == sql.ErrNoRows {
		replies = nil
	} else if err != nil {
		return nil, err
	}
	for rows.Next() {
		var id, replyNum int64
		var comment string
		if err := rows.Scan(&id, &replyNum, &comment); err != nil {
			return nil, err
		}
		var replyReports []Report
		reportRows, err := tx.Query("select type, reason from "+R_REPORT_TABLE+" where id = ?", id)
		if err == sql.ErrNoRows {
			replyReports = nil
		} else if err != nil {
			return nil, err
		}
		for reportRows.Next() {
			var typ, reason string
			if err := reportRows.Scan(&typ, &reason); err != nil {
				return nil, err
			}
			replyReports = append(replyReports, Report{
				Type:   typ,
				Reason: reason,
			})
		}
		replies = append(replies, Reply{
			Id:      replyNum,
			Message: comment,
			Reports: replyReports,
		})
		sort.Sort(ReplySlice(replies))
		reportRows.Close()
	}
	rows.Close()

	// split comma separated tag list
	tags := ParseTagString(rawTags)

	// split attachment list
	var attachments []string
	if attachmentUri != "" {
		attachments = strings.Split(attachmentUri, ",")
		for i, a := range attachments {
			attachments[i] = strings.TrimSpace(a)
		}
	}

	post := &Post{
		Id:            postId,
		Message:       message,
		Tags:          tags,
		TimesShared:   timesShared,
		DatePosted:    date,
		Reports:       reports,
		Replies:       replies,
		AttachmentUri: attachments,
		// posts from the database have already been finalized
		isFinal: true,
	}
	return post, nil
}

// delete a post specified by id from the database using an optional delcode;
// if the post is stored with a delcode, and the supplied delcode does not match,
// then an ErrUnauthorized is returned; similarly, if a delcode is supplied and
// the Post does not have a delcode attached, an ErrUnauthorized is returned.
//
// delcode must the cleartext of the deletion passphrase if any.
func deletePost(tx *sql.Tx, id int64, delcode string) error {
	var hash, salt string
	err := tx.QueryRow("select hash, salt from "+P_DELCODE_TABLE+" where id = ?").Scan(&hash, &salt)
	if err == sql.ErrNoRows {
		// if delcode supplied but post not protected
		if delcode != "" {
			return ErrUnauthorized
		}
		// else if post is unprotected and no code specified, simply remove the
		// post
		return removePost(tx, id)
	} else if err != nil {
		return err
	}

	// check supplied code against the stored hash
	err = bcrypt.CompareHashAndPassword([]byte(hash), []byte(delcode+salt))
	if err != nil {
		return ErrUnauthorized
	}

	return removePost(tx, id)
}

// remove row from specified table by numeric id column; intended to be used on
// tables which have integer primary keys matching 'id' --- use carefully
func removeRows(tx *sql.Tx, id int64, tab, col string) error {
	del, err := tx.Prepare("delete from " + tab + " where " + col + " = ?")
	if err != nil {
		return err
	}
	_, err = del.Exec(id)
	return err
}

// remove a post (and all replies) by post id
func removePost(tx *sql.Tx, id int64) error {
	p, err := getPost(tx, id)
	if p == nil {
		return ErrPostNotFound
	} else if err != nil {
		return err
	}

	// get private db reply ids and delete delcodes and reports
	rows, err := tx.Query("select id from replies where parent = ?", id)
	for rows.Next() {
		var r int64
		rows.Scan(&r)
		if err := removeRows(tx, r, R_DELCODE_TABLE, "id"); err != nil {
			return err
		}
		if err := removeRows(tx, r, R_REPORT_TABLE, "id"); err != nil {
			return err
		}
	}

	if err := removeRows(tx, id, REPLY_TABLE, "parent"); err != nil {
		return err
	}
	if err := removeRows(tx, id, P_DELCODE_TABLE, "id"); err != nil {
		return err
	}
	if err := removeRows(tx, id, P_REPORT_TABLE, "id"); err != nil {
		return err
	}
	if err := removeRows(tx, id, POST_TABLE, "id"); err != nil {
		return err
	}
	return nil
}
