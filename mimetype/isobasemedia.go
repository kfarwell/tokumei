package mimetype

import "strings"

const (
	ISOBASEPREFIX string = "ftyp"
)

func isoMediaIdent(b []byte, ext string) (string, error) {
	/* file type identifiers (proceed "ftyp") */
	// http://www.file-recovery.com/m4a-signature-format.htm
	m4aTypes := []string{"M4A\x20", "M4B\x20", "M4P\x20"}
	// http://www.file-recovery.com/m4a-signature-format.htm
	mp4Types := []string{"avc1", "iso2", "isom", "mmp4", "mp41", "mp42", "mp71", "msnv", "ndas", "ndsc", "ndsh", "ndsm", "ndsp", "ndss", "ndxc", "ndxh", "ndxm", "ndxp", "ndxs"}
	// http://www.file-recovery.com/3gp-signature-format.htm
	_3gpTypes := []string{"3ge6", "3ge7", "3gg6", "3gp1", "3gp2", "3gp3", "3gp4", "3gp5", "3gp6", "3gp7", "3gr6", "3gr7", "3gs6", "3gs7", "kddi"}

	s := string(b) // byte stream less the leading size identifier
	if !strings.HasPrefix(s, ISOBASEPREFIX) {
		return "", ErrBadFile
	} else {
		s = strings.TrimPrefix(s, ISOBASEPREFIX)
	}
	switch strings.ToLower(ext) {
	case "m4b":
		fallthrough
	case "m4p":
		fallthrough
	case "m4a":
		for _, v := range m4aTypes {
			if strings.HasPrefix(s, v) {
				return "audio/mp4", nil
			}
		}
	case "mp4":
		for _, v := range mp4Types {
			if strings.HasPrefix(s, v) {
				return "video/mp4", nil
			}
		}
	case "m4v":
		// http://www.file-recovery.com/m4v-signature-format.htm
		if strings.HasPrefix(s, "M4V\x20") {
			return "video/x-m4v", nil
		}
	case "mov": // quicktime format; same as *.qt
		fallthrough
	case "qt":
		// http://www.file-recovery.com/mov-signature-format.htm
		if strings.HasPrefix(s, "qt\x20\x20") {
			return "video/quicktime", nil
		}
	case "3gpp":
		fallthrough
	case "3gp":
		for _, v := range _3gpTypes {
			if strings.HasPrefix(s, v) {
				return "video/3gpp", nil
			}
		}
	}
	return "", ErrUnsupportedFile
}
