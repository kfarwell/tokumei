/* Copyright (c) 2017-2018 Tokumei authors.
 * This software package is licensed for use under the ISC license.
 * See LICENSE for details.
 *
 * Tokumei is a simple, self-hosted microblogging platform. */

// Package timedate contains functions that deal with (anonymized) time/date
// stamps.
package timedate

import (
	"fmt"
	"time"
)

// UnixDateStamp takes an epoch time stamp and strips out any unique identifying
// hour, minute, sec, and nanosec parts. An anonymized unix "datestamp" is
// returned as 00:00:00 UTC on the same day. It is reasoned that a date is a
// wide-enough time interval to be useful for sorting data chronologically using
// other proxies (such as a recorded order of submittal) while making it more
// difficult to fingerprint individual data.
func UnixDateStamp(sec int64) int64 {
	var t time.Time
	if sec >= 0 {
		t = time.Unix(sec, 0)
	} else {
		t = time.Now()
	}
	y, m, d := t.Date()
	t = time.Date(y, m, d, 0, 0, 0, 0, time.UTC)
	return t.Unix()
}

// ParseUnixDate converts an epoch time stamp into an anonymized UTC "datestamp"
// formatted as "dd MMM yyyy". If sec is negative, this function returns the
// current datestamp.
func ParseUnixDate(sec int64) string {
	var t time.Time
	if sec >= 0 {
		t = time.Unix(sec, 0)
	} else {
		t = time.Now()
	}
	t = t.UTC()
	y, m, d := t.Date()
	return fmt.Sprintf("%02d %s %d", d, fmt.Sprintf("%.3s", m.String()), y)
}
