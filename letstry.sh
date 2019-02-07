#!/bin/bash
# Ruby at a character other than the beginning of a phrase should be prefixedby ｜.


LC_COLLATE=C.UTF-8 sed \
    -e 's/｜\([^(]*\) \(([^)]*)\) /<ruby>\1<rt>\2<\/rt><\/ruby>/g' \
    -e 's/^\([^(]*\) \(([^)]*)\) /<ruby>\1<rt>\2<\/rt><\/ruby>/' \
    $1 > $1.md

