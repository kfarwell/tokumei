/* Copyright (c) 2017-2018 Tokumei authors.
 * This software package is licensed for use under the ISC license.
 * See LICENSE for details.
 *
 * Tokumei is a simple, self-hosted microblogging platform. */

package srv

import (
	"encoding/json"
	"errors"
	"fmt"
	"io/ioutil"
	"path/filepath"
)

// CFG is the name of the server configuration directory
const CFG string = "cfg"

// Constant constraints for Settings
const (
	MIN_ATTACHMENTS int = 0
	MAX_ATTACHMENTS int = 4
)

// CFGFILE is the path to the JSON formatted config file for this Tokumei server.
// See the tokumei/srv package to better understand server configuration.
var CFGFILE string = filepath.FromSlash(CFG + "/config.json")

// Default server operation settings
var (
	Port    string = "3003"
	Verbose bool   = false
)

// Errors
var (
	ErrInvalidFilePath  = errors.New("srv settings: path to configuration file is invalid")
	ErrNil              = errors.New("srv settings: nil Settings is invalid")
	ErrBadAttachmentNum = errors.New("srv settings: Settings.MaxAttachmentNum not in allowable range")
)

// Settings is a struct which contains all configuration settings for this
// Tokumei instance.
type Settings struct {
	/* General settings */
	Title        string       `json:"site_title"`           // site title
	Subtitle     string       `json:"site_subtitle"`        // site subtitle shown on landing page
	Description  string       `json:"meta_description"`     // meta description used in search results
	Lang         string       `json:"lang"`                 // site-wide locale
	Host         string       `json:"host"`                 // ex. blog.example.com
	Port         uint         `json:"port"`                 // default: 1337
	IsPrivate    bool         `json:"private_installation"` // if true, require accounts to make posts
	Features     Features     `json:"features"`             // enabled/disable features
	PrivateConf  PrivateConf  `json:"private_conf"`         // private site configurations
	PostConf     PostConf     `json:"post_conf"`            // post configurations
	TrendingConf TrendingConf `json:"trending_conf"`        // trending algorithm tweaks
	DonationConf DonationConf `json:"donation_conf"`        // donation configurations
	Webmaster    Webmaster    `json:"webmaster_info"`       // webmaster identity
}

// Features is a struct containing settings that enable or disable certain
// features of this Tokumei instance.
type Features struct {
	AllowDonations bool `json:"allow_donations"`  // if true, add 'donate' page to site footer
	ProvideApiKeys bool `json:"provide_api_keys"` // enable or disable API key requests and generation
	Search         bool `json:"enable_search"`    // enable or disable search by tag
	Themes         bool `json:"enable_themes"`    // enable or disable custom themes
	Trending       bool `json:"enable_trends"`    // enable or disable the trending index
}

// PrivateConf is a struct containing settings pertaining to a private Tokumei
// instance. These settings are ignored Conf.IsPrivate is false.
type PrivateConf struct {
	EnableRegistration bool `json:"enable_registration"` // allow web registration for private sites
	ShowSignUpStub     bool `json:"show_signup_stub"`    // show button for web registration
}

// PostConf is a struct containing configuration settings.
//
// Note: If RequireCaptcha is set to true, then a captcha challenge must be
// completed before a post can be submitted; submitting posts using an API key
// will allow a poster to skip this requirement.
type PostConf struct {
	CharLimit           int    `json:"char_limit"`                       // number of chars in post excluding tags
	MaxAttachmentNum    int    `json:"max_attachment_num"`               // maximum number of attachments allowed per post; 0 through 4 allowed
	MaxFileSize         uint64 `json:"max_filesize"`                     // file size limit for individual attachments
	ForceTagging        bool   `json:"force_tagging"`                    // require at least one tag for post
	EnableReplies       bool   `json:"enable_replies"`                   // enable or disable replies on posts
	EnableWebDelete     bool   `json:"enable_web_delete"`                // enable or disable post deletion by users
	EnableReportSpam    bool   `json:"enable_spam_reporting"`            // enable or disable spam reports by users
	EnableReportIllegal bool   `json:"enable_illegal_content_reporting"` // enable or disable illegal content reports
	RequireCaptcha      bool   `json:"require_captcha"`                  // post captcha requirement
}

// TrendingConf is struct that contains settings that tailor the trending
// alogorithms used by this Tokumei instance.
//
// Read our guides at https://gitlab.com/tokumei/hosting to understand how to change
// these values.
type TrendingConf struct {
	Interval uint `json:"trending_interval"` // number in seconds to be scaled by size of site
}

// Webmaster is a struct which is populated with data about the webmaster of
// this Tokumei instance. It is useful for users to identify who is running this
// website, so that issues may be reported, etc.
type Webmaster struct {
	Name  string `json:"name"`  // name or nickname of the webmaster
	Email string `json:"email"` // contact email for webmaster
}

// DonationConf is a struct containing settings pertaining to donations. These
// settings are ignored if Features.AllowDonations is set to false.
type DonationConf struct {
	Btc    string `json:"btc_address"` // bitcoin address
	Paypal Paypal `json:"paypal"`      // paypal conf
}

// Paypal is a struct containing information about the webmaster's Paypal
// account used for donations.
type Paypal struct {
	Enabled     bool   `json:"enabled"`      // toggle paypal
	Id          string `json:"id"`           // paypal ID
	Currency    string `json:"currency"`     // preferred currency
	CountryCode string `json:"country_code"` // country code
	Name        string `json:"name"`         // paypal name
}

// Settings' implementation of the Stringer interface prints formatted JSON.
func (s Settings) String() string {
	res, err := json.MarshalIndent(s, "", "  ")
	var ret string
	if err != nil {
		ret = err.Error()
	} else {
		ret = string(res)
	}
	return fmt.Sprintf("%s", ret)
}

// Conf is the runtime Settings for the server.
var Conf Settings

// ReadConfig() reads the JSON-formatted configuration file located the specified
// file path.
func (s *Settings) ReadConfig(file string) error {
	if file == "" {
		return ErrInvalidFilePath
	}

	buf, err := ioutil.ReadFile(file)
	if err != nil {
		return err
	}

	return json.Unmarshal(buf, s)
}

// ValidateConfig() validates the data held in a Settings struct.
func (s *Settings) ValidateConfig() error {
	if s == nil {
		return ErrNil
	}
	if s.PostConf.MaxAttachmentNum < MIN_ATTACHMENTS || s.PostConf.MaxAttachmentNum > MAX_ATTACHMENTS {
		return ErrBadAttachmentNum
	}

	return nil
}
