package mimetype

import (
	"os"
	"testing"
)

func TestMain(m *testing.M) {
	os.Exit(m.Run())
}

func TestGetFileType(t *testing.T) {
	/* test image formats */
	// test ico
	if ico, err := GetFileType(".res/tokumei.ico"); err != nil {
		t.Fatal(err)
	} else if ico.Mimetype != "image/vnd.microsoft.icon" {
		t.Errorf("expected image/vnd.microsoft.icon; got %s\n", ico.Mimetype)
	}
	// test jpeg
	if jpg, err := GetFileType(".res/tokumei.jpg"); err != nil {
		t.Fatal(err)
	} else if jpg.Mimetype != "image/jpeg" {
		t.Errorf("expected image/jpeg; got %s\n", jpg.Mimetype)
	}
	// test png
	if png, err := GetFileType(".res/tokumei.png"); err != nil {
		t.Fatal(err)
	} else if png.Mimetype != "image/png" {
		t.Errorf("expected image/png; got %s\n", png.Mimetype)
	}
	// test gif
	if gif, err := GetFileType(".res/tokumei.gif"); err != nil {
		t.Fatal(err)
	} else if gif.Mimetype != "image/gif" {
		t.Errorf("expected image/gif; got %s\n", gif.Mimetype)
	}
	// test tiff
	if tif, err := GetFileType(".res/tokumei.tiff"); err != nil {
		t.Fatal(err)
	} else if tif.Mimetype != "image/tiff" {
		t.Errorf("expected image/tiff; got %s\n", tif.Mimetype)
	}
	// test bmp
	if bmp, err := GetFileType(".res/tokumei.bmp"); err != nil {
		t.Fatal(err)
	} else if bmp.Mimetype != "image/bmp" {
		t.Errorf("expected image/bmp; got %s\n", bmp.Mimetype)
	}
	// test webp
	if webp, err := GetFileType(".res/1_webp_a.webp"); err != nil {
		t.Fatal(err)
	} else if webp.Mimetype != "image/webp" {
		t.Errorf("expected image/webp; got %s\n", webp.Mimetype)
	}
	if webpl, err := GetFileType(".res/1_webp_ll.webp"); err != nil {
		t.Fatal(err)
	} else if webpl.Mimetype != "image/webp" {
		t.Errorf("expected image/webp; got %s\n", webpl.Mimetype)
	}
	// test svg
	if svg, err := GetFileType(".res/tokumei_plain.svg"); err != nil {
		t.Fatal(err)
	} else if svg.Mimetype != "image/svg+xml" {
		t.Errorf("expected image/svg+xml; got %s\n", svg.Mimetype)
	}
	if svgxml, err := GetFileType(".res/tokumei.svg"); err != nil {
		t.Fatal(err)
	} else if svgxml.Mimetype != "image/svg+xml" {
		t.Errorf("expected image/svg+xml; got %s\n", svgxml.Mimetype)
	}

	/* test audio formats */
	// test ogg
	if ogg, err := GetFileType(".res/M1F1-mulawWE-AFsp.ogg"); err != nil {
		t.Fatal(err)
	} else if ogg.Mimetype != "audio/ogg" {
		t.Errorf("expected audio/ogg; got %s\n", ogg.Mimetype)
	}
	if opus, err := GetFileType(".res/M1F1-mulawWE-AFsp.opus"); err != nil {
		t.Fatal(err)
	} else if opus.Mimetype != "audio/ogg" {
		t.Errorf("expected audio/ogg; got %s\n", opus.Mimetype)
	}
	// test flac
	if flac, err := GetFileType(".res/M1F1-mulawWE-AFsp.flac"); err != nil {
		t.Fatal(err)
	} else if flac.Mimetype != "audio/x-flac" {
		t.Errorf("expected audio/x-flac; got %s\n", flac.Mimetype)
	}
	// test m4a
	if m4a, err := GetFileType(".res/M1F1-mulawWE-AFsp.m4a"); err != nil {
		t.Fatal(err)
	} else if m4a.Mimetype != "audio/mp4" {
		t.Errorf("expected audio/mp4; got %s\n", m4a.Mimetype)
	}
	// test mp3
	if id3v1, err := GetFileType(".res/M1F1-mulawWE-AFsp_ID3v1.mp3"); err != nil {
		t.Fatal(err)
	} else if id3v1.Mimetype != "audio/mpeg" {
		t.Errorf("expected audio/mpeg; got %s\n", id3v1.Mimetype)
	}
	if id3v2, err := GetFileType(".res/M1F1-mulawWE-AFsp_ID3v2.mp3"); err != nil {
		t.Fatal(err)
	} else if id3v2.Mimetype != "audio/mpeg" {
		t.Errorf("expected audio/mpeg; got %s\n", id3v2.Mimetype)
	}
	// test wav
	if wav, err := GetFileType(".res/M1F1-mulawWE-AFsp.wav"); err != nil {
		t.Fatal(err)
	} else if wav.Mimetype != "audio/x-wav" {
		t.Errorf("expected audio/x-wav; got %s\n", wav.Mimetype)
	}

	/* test video formats */
	// test 3gpp
	if _3gp, err := GetFileType(".res/sample.3gp"); err != nil {
		t.Fatal(err)
	} else if _3gp.Mimetype != "video/3gpp" {
		t.Errorf("expected video/3gpp; got %s\n", _3gp.Mimetype)
	}
	// test webm
	if webm, err := GetFileType(".res/tokumei-demo.webm"); err != nil {
		t.Fatal(err)
	} else if webm.Mimetype != "video/webm" {
		t.Errorf("expected video/webm; got %s\n", webm.Mimetype)
	}
	// test avi
	if avi, err := GetFileType(".res/tokumei-demo.avi"); err != nil {
		t.Fatal(err)
	} else if avi.Mimetype != "video/x-msvideo" {
		t.Errorf("expected video/x-msvideo; got %s\n", avi.Mimetype)
	}
	// test matroska
	if mkv, err := GetFileType(".res/tokumei-demo.mkv"); err != nil {
		t.Fatal(err)
	} else if mkv.Mimetype != "video/x-matroska" {
		t.Errorf("expected video/x-matroska; got %s\n", mkv.Mimetype)
	}
	// test mp4
	if mp4, err := GetFileType(".res/tokumei-demo.mp4"); err != nil {
		t.Fatal(err)
	} else if mp4.Mimetype != "video/mp4" {
		t.Errorf("expected video/mp4; got %s\n", mp4.Mimetype)
	}

	/* test archive formats */
	/* test other formats */
	if xml, err := GetFileType(".res/sample.xml"); err != nil {
		t.Fatal(err)
	} else if xml.Mimetype != "text/xml" {
		t.Errorf("expected text/xml; got %s\n", xml.Mimetype)
	}

}
