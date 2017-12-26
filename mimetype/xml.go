package mimetype

import (
	"fmt"
	"regexp"
	"strings"
)

// XML documents can contain any arbitrary information, but few specific formats
// really matter such as SVG and KML data.
// This function does *not* validate XML data, but rather attempts to identify
// the kind of data by prefix patterns.
func xmlIdent(b []byte) (string, error) {
	s := string(b)
	if !strings.HasPrefix(s, "<?xml") && !strings.HasPrefix(s, "<!doctype") {
		fmt.Println("here")
		return "", ErrBadFile
	}
	svgPattern := regexp.MustCompile(`^\s*(<\?[xX][mM][lL][^>]*>\s*)?(<![dD][oO][cC][tT][yY][pP][eE]\s+[sS][vV][gG][^>]*>)?(<[sS][vV][gG][^>]*>\s*)`)
	if svgPattern.Match(b) {
		return "image/svg+xml", nil
	}
	return "text/xml", nil
}
