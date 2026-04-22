#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────
#  ~/.config/lf/previewer.sh
#  Called by lf as:  previewer.sh  FILE  WIDTH  HEIGHT  X  Y
# ──────────────────────────────────────────────────────────
FILE="$1"
W="${2:-80}"
H="${3:-40}"
X="${4:-0}"
Y="${5:-0}"

# Resolve symlinks
FILE="$(readlink -f "$FILE" 2>/dev/null || printf '%s' "$FILE")"
EXT="${FILE##*.}"
EXT="${EXT,,}"   # lowercase

# ── helpers ───────────────────────────────────────────────
has() { command -v "$1" >/dev/null 2>&1; }

# Syntax-highlighted text via bat, fallback to cat
show_text() {
    if has bat; then
        bat --color=always --style=numbers,changes \
            --line-range ":${H}" -- "$FILE" 2>/dev/null
    else
        head -n "$H" -- "$FILE"
    fi
}

# ── dispatch by extension ─────────────────────────────────
case "$EXT" in

    # ── plain text / markup ───────────────────────────────
    txt|md|markdown|rst|adoc|asciidoc|asc|textile|wiki|org|\
    csv|tsv|psv)
        show_text ;;

    # ── structured / data ─────────────────────────────────
    json|jsonc|json5|ndjson|geojson)
        if has jq; then
            jq --color-output . "$FILE" 2>/dev/null | head -n "$H"
        else
            show_text
        fi ;;

    toml|yaml|yml|xml|rss|atom|xlf|xsd|xsl|xslt)
        show_text ;;

    # ── source code & configs (everything nvim opens) ─────
    conf|cfg|ini|env|properties|editorconfig|\
    gitconfig|gitignore|gitattributes|gitmodules|\
    dockerignore|hgignore|npmignore|\
    profile|bashrc|zshrc|zshenv|zprofile|bash_profile|\
    inputrc|xinitrc|xprofile|Xresources|xdefaults|\
    tmux.conf|tigrc|curlrc|wgetrc|ripgreprc|\
    flake8|pylintrc|pyproject|setup.cfg|\
    clang-format|clang-tidy|\
    makefile|cmake|meson|ninja|bazel|buck|build|\
    dockerfile|containerfile|\
    service|socket|timer|target|mount|automount|path|slice|\
    desktop|\
    py|pyw|pyx|pxd|pxi|ipynb|\
    c|cpp|cc|cxx|c++|h|hpp|hh|hxx|h++|m|mm|\
    js|jsx|ts|tsx|mjs|cjs|vue|svelte|astro|mdx|\
    html|htm|xhtml|\
    css|scss|sass|less|stylus|styl|\
    rs|go|zig|asm|s|nasm|v|\
    java|kt|kts|groovy|gradle|scala|clj|cljs|cljc|edn|\
    cs|fs|fsx|vb|\
    rb|erb|rake|gemspec|pl|pm|t|php|phtml|inc|\
    sh|bash|zsh|fish|ps1|psm1|psd1|bat|cmd|vbs|\
    hs|lhs|ml|mli|el|lisp|cl|rkt|scm|ss|fnl|janet|\
    lua|vim|nvim|tcl|tk|r|jl|ex|exs|erl|hrl|nim|cr|\
    sql|sqlite|ddl|dml|\
    j2|jinja|jinja2|mustache|hbs|handlebars|ejs|tpl|\
    tf|tfvars|hcl|nomad|\
    proto|thrift|avsc|graphql|gql|wgsl|glsl|frag|vert|hlsl|\
    log|out|err|trace|\
    tex|ltx|sty|cls|dtx|ins|bib|bbl)
        show_text ;;

    # ── diff / patch ──────────────────────────────────────
    diff|patch)
        if has delta; then
            delta --no-gitconfig --color-only < "$FILE" | head -n "$H"
        else
            show_text
        fi ;;

    # ── PDF ───────────────────────────────────────────────
    pdf)
        if has pdftotext; then
            pdftotext -l 3 -nopgbrk "$FILE" - 2>/dev/null | head -n "$H"
        elif has mutool; then
            mutool draw -F text "$FILE" 2>/dev/null | head -n "$H"
        else
            printf '[PDF — install poppler for text preview]\n'
        fi ;;

    # ── images ────────────────────────────────────────────
    jpg|jpeg|jpe|jfif|png|webp|avif|heic|heif|\
    gif|apng|bmp|tiff|tif|ppm|pgm|pbm|pnm|\
    ico|cur|xpm|xbm|svg|svgz)
        if has ueberzugpp; then
            ueberzugpp cmd -s "$UB_SOCKET" -a add -i lf_preview \
                -x "$X" -y "$Y" --max-width "$W" --max-height "$H" \
                -c 'Image' --path "$FILE" 2>/dev/null
        elif has chafa; then
            chafa --size="${W}x${H}" -- "$FILE" 2>/dev/null
        else
            has identify && identify "$FILE" 2>/dev/null \
                || printf '[image — install ueberzugpp or chafa]\n'
        fi ;;

    # ── video ─────────────────────────────────────────────
    mp4|mkv|webm|avi|mov|wmv|flv|f4v|3gp|3g2|\
    ts|m2ts|mts|m4v|ogv|vob|divx|xvid|mpeg|mpg|m2v|\
    rm|rmvb|asf|mxf|dv|yuv)
        # Show a thumbnail if possible, then mediainfo
        if has ffmpegthumbnailer && has chafa; then
            THUMB="$(mktemp /tmp/lf-thumb-XXXXXX.jpg)"
            ffmpegthumbnailer -i "$FILE" -o "$THUMB" -s 0 -q 5 2>/dev/null \
                && chafa --size="${W}x$((H/2))" -- "$THUMB"
            rm -f "$THUMB"
        fi
        if has mediainfo; then
            mediainfo "$FILE" 2>/dev/null | head -n "$H"
        elif has ffprobe; then
            ffprobe -v quiet -print_format flat -show_format -show_streams \
                "$FILE" 2>/dev/null | head -n "$H"
        else
            printf '[video — install mediainfo for metadata]\n'
        fi ;;

    # ── audio ─────────────────────────────────────────────
    mp3|flac|ogg|opus|wav|aiff|aif|m4a|aac|wma|mka|\
    ape|wv|tta|mpc|spx|amr|ac3|dts|mid|midi|xm|mod|s3m|it)
        if has mediainfo; then
            mediainfo "$FILE" 2>/dev/null | head -n "$H"
        elif has ffprobe; then
            ffprobe -v quiet -print_format flat -show_format -show_streams \
                "$FILE" 2>/dev/null | head -n "$H"
        elif has exiftool; then
            exiftool "$FILE" 2>/dev/null | head -n "$H"
        else
            printf '[audio — install mediainfo for metadata]\n'
        fi ;;

    # ── archives ──────────────────────────────────────────
    zip|jar|war|ear|whl|nupkg|apk|cbz)
        has unzip && unzip -Z1 "$FILE" 2>/dev/null | head -n "$H" \
            || printf '[zip — install unzip]\n' ;;

    tar)      has tar && tar tf  "$FILE" 2>/dev/null | head -n "$H" ;;
    tgz|tar.gz)  has tar && tar tzf "$FILE" 2>/dev/null | head -n "$H" ;;
    tbz2|tar.bz2) has tar && tar tjf "$FILE" 2>/dev/null | head -n "$H" ;;
    txz|tar.xz)  has tar && tar tJf "$FILE" 2>/dev/null | head -n "$H" ;;
    tzst|tar.zst)
        has tar && tar -I unzstd -tf "$FILE" 2>/dev/null | head -n "$H" ;;

    gz)  has zcat   && zcat   "$FILE" 2>/dev/null | head -n "$H" ;;
    bz2) has bzcat  && bzcat  "$FILE" 2>/dev/null | head -n "$H" ;;
    xz)  has xzcat  && xzcat  "$FILE" 2>/dev/null | head -n "$H" ;;
    zst) has unzstd && unzstd -c "$FILE" 2>/dev/null | head -n "$H" ;;

    7z|cab|iso|cbr|cb7|rar)
        has 7z && 7z l "$FILE" 2>/dev/null | head -n "$H" \
            || printf '[archive — install p7zip]\n' ;;

    deb)
        has dpkg-deb && dpkg-deb -I "$FILE" 2>/dev/null \
            && dpkg-deb -c "$FILE" 2>/dev/null | head -n "$((H-10))" ;;

    rpm)
        has rpm && rpm -qip "$FILE" 2>/dev/null \
            || { has 7z && 7z l "$FILE" 2>/dev/null | head -n "$H"; } ;;

    # ── office / document ─────────────────────────────────
    odt|odp|odg|odb|odf|ods|odm|\
    doc|docx|dot|dotx|rtf|\
    xls|xlsx|xlsm|xlt|xltx|\
    ppt|pptx|pot|potx)
        if has libreoffice; then
            # Try docx2txt / xlsx parsing; LO is too slow for preview
            :
        fi
        if has catdoc && [[ "$EXT" == doc ]]; then
            catdoc "$FILE" 2>/dev/null | head -n "$H"
        elif has docx2txt && [[ "$EXT" == docx ]]; then
            docx2txt "$FILE" - 2>/dev/null | head -n "$H"
        elif has pandoc; then
            pandoc -t plain "$FILE" 2>/dev/null | head -n "$H"
        elif has unzip && [[ "$EXT" =~ ^(docx|xlsx|pptx|odt|ods|odp)$ ]]; then
            # Raw XML fallback — at least shows structure
            unzip -p "$FILE" "word/document.xml" \
                             "xl/sharedStrings.xml" \
                             "ppt/slides/slide1.xml" \
                             "content.xml" 2>/dev/null \
                | sed 's/<[^>]*>//g' | tr -s ' \n' '\n' | head -n "$H"
        else
            printf '[office file — install pandoc or docx2txt for preview]\n'
        fi ;;

    # ── ebooks ────────────────────────────────────────────
    epub)
        if has pandoc; then
            pandoc -t plain "$FILE" 2>/dev/null | head -n "$H"
        elif has unzip; then
            unzip -p "$FILE" "*.html" "*.xhtml" "*.htm" "OEBPS/*.html" 2>/dev/null \
                | sed 's/<[^>]*>//g' | tr -s ' \n' '\n' | head -n "$H"
        else
            printf '[epub — install pandoc for preview]\n'
        fi ;;

    djvu)
        has djvutxt && djvutxt "$FILE" 2>/dev/null | head -n "$H" \
            || printf '[djvu — install djvulibre for preview]\n' ;;

    fb2)  show_text ;;   # FB2 is XML, bat handles it fine

    # ── fonts ─────────────────────────────────────────────
    ttf|otf|woff|woff2|eot|ttc)
        has fc-query && fc-query "$FILE" 2>/dev/null | head -n "$H" \
            || printf '[font file]\n' ;;

    # ── torrent ───────────────────────────────────────────
    torrent)
        has transmission-show && transmission-show "$FILE" 2>/dev/null \
            || { has aria2c && aria2c -S "$FILE" 2>/dev/null | head -n "$H"; } \
            || printf '[torrent — install transmission-cli for preview]\n' ;;

    # ── catch-all ─────────────────────────────────────────
    *)
        # If file reports text MIME → show it
        if file --mime-type "$FILE" 2>/dev/null | grep -q 'text/'; then
            show_text
        # Binary with known image MIME → try chafa
        elif file --mime-type "$FILE" 2>/dev/null | grep -q 'image/'; then
            has chafa && chafa --size="${W}x${H}" -- "$FILE" 2>/dev/null \
                || printf '[image]\n'
        else
            printf '[binary file — no preview available]\n'
            file --brief -- "$FILE" 2>/dev/null
        fi ;;
esac

exit 0
