#!/bin/bash
# It requires MultimediaDAISY2.02 files under directory $1 consisting of only one section. $2 is a project name.
# create base md
echo '---' > $2.md
echo 'layout: caymanyomi' >> $2.md
echo 'title: ' >> $2.md
echo 'author: 音訳グループ やまびこ' >> $2.md
echo 'date: '`date +%Y-%m-%dT%TZ` >> $2.md
echo 'oto: '$2'/sound0001' >> $2.md
echo 'iro: ' >> $2.md
echo 'gra: ' >> $2.md
echo 'background: '$2'/default.jpg' >> $2.md
echo 'imagefrom: ' >> $2.md
echo 'imagefromurl: ' >> $2.md
echo 'navigation: true' >> $2.md
echo '---' >> $2.md
echo '   ' >> $2.md

# go to working dir
cd $1
# extract begin-end time
sed \
    -e 's/^.* id=\"\([a-zA-Z0-9_]*\)\".*npt=\([0-9\.]*\)s.*npt=\([0-9\.]*\)s.*/\2\t\3\t\1\t/' \
    -e '/ *</d' \
    mrii0001.smil > begin-end.tsv
# extract paroles
sed \
    -e 's/<\/span><span id=/<\/span>\n<span id=/g' \
    -e 's/<\/span>\&ensp;<span id=/<\/span>\n<span id=/g' \
    index.html > temp
sed \
    -e 's/^.*span id=\"[a-zA-Z0-9_]*\">\(.*\)<\/span.*$/\1/' \
    -e '/^[ \t]*</d' \
    -e 's/<span [a-zA-Z0-9_\"=]*>//g' \
    -e 's/<\/span>//g' \
    temp > paroles.tsv
# calculate dur-begin.tsv
awk '{
    printf("%s\t%3.3f\n", $2-$1, $1)
    }' \
    begin-end.tsv > dur-begin.tsv
# combine dur-begin.tsv and paroles.tsv
paste dur-begin.tsv paroles.tsv > base.tsv
# make span
sed \
    -e 's/\([0-9\.]*\)\t\([0-9\.]*\)\t\(（リンク）\)/<a href=\"\" data-dur=\"\1\" data-begin=\"\2\">\3<\/a><\/span>/' \
    -e 's/\([0-9\.]*\)\t\([0-9\.]*\)\t\(.*\)/<span data-dur=\"\1\" data-begin=\"\2\">\3<\/span>/' \
    base.tsv >> ../$2.md
# remove temp files
#rm *.tsv temp
cd sounds
../../wav2mp3ogg.sh
cd -
mkdir -p ../media/$2
cp -i sounds/* ../media/$2
cd ..

