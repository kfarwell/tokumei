package main

import (
    "github.com/russross/blackfriday"
    "github.com/microcosm-cc/bluemonday"
    "os"
    "io/ioutil"
)

func main() {
    const (
        flags = 0 |
            blackfriday.HTML_USE_XHTML |
            blackfriday.HTML_USE_SMARTYPANTS |
            blackfriday.HTML_SMARTYPANTS_FRACTIONS |
            blackfriday.HTML_SMARTYPANTS_LATEX_DASHES
        extensions = 0 |
            blackfriday.EXTENSION_NO_INTRA_EMPHASIS |
            blackfriday.EXTENSION_TABLES |
            blackfriday.EXTENSION_FENCED_CODE |
            blackfriday.EXTENSION_AUTOLINK |
            blackfriday.EXTENSION_STRIKETHROUGH |
            blackfriday.EXTENSION_SPACE_HEADERS |
            blackfriday.EXTENSION_HARD_LINE_BREAK |
            blackfriday.EXTENSION_NO_EMPTY_LINE_BEFORE_BLOCK
    )
    renderer := blackfriday.HtmlRenderer(flags, "", "")

    input, _ := ioutil.ReadAll(os.Stdin)

    unsafe := blackfriday.Markdown(input, renderer, extensions)
    safe := bluemonday.UGCPolicy().SanitizeBytes(unsafe)

    out := os.Stdout
    out.Write(safe)
}
