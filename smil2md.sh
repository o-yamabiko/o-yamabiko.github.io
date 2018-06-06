#!/bin/bash
# Ruby at a character other than the beginning of a phrase should be prefixedby ｜.
# It requires MultimediaDAISY2.02 files under directory $1 consisting of only one section. $2 is a project name.

YEAR="`echo $2 | sed -e 's/tusin\([0-9][0-9][0-9][0-9]\)[01][0-9]/\1/'`"
MONTH2="`echo $2 | sed -e 's/tusin[0-9][0-9][0-9][0-9]\([01][0-9]\)/\1/'`"
if [[ $MONTH2 == '0'* ]]; then
  MONTH1="`echo $MONTH2 | sed -e 's/0\([0-9]\)/\1/'`"
else
  MONTH1=$MONTH2
fi

# create base md
echo '---' > $2.md
echo 'layout: caymanyomi' >> $2.md

# if tusinYYYYmm
if [[ $2 != tusin* ]]; then
  echo 'title: ' >> $2.md
else
  echo 'title: やまびこ通信'$YEAR'年'$MONTH1'月号' >> $2.md
fi

echo 'author: 音訳グループ やまびこ' >> $2.md
echo 'date: '`date +%Y-%m-%dT%TZ` >> $2.md
echo 'oto: '$2'/sound0001' >> $2.md
echo 'iro: ' >> $2.md
echo 'gra: ' >> $2.md
echo 'background: '$2'/default.png' >> $2.md
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
LC_COLLATE=C.UTF-8 sed \
    -e 's/<span class=\"infty_silent\">\([^｜<]*\)<\/span>/SILENT<\1>SILENT/g' \
    -e 's/<\/span><span id=/<\/span>\n<span id=/g' \
    -e 's/<\/span>\&ensp;<span id=/<\/span>\n<span id=/g' \
    -e 's/<\/span>\&nbsp; <span id=/<\/span>\n<span id=/g' \
    index.html > temp1
sed \
    -e 's/^.*span id=\"[a-zA-Z0-9_]*\">\(.*\)<\/span.*$/\1/' \
    -e '/^[ \t]*</d' \
    -e 's/<span [a-zA-Z0-9_\"=]*>//g' \
    -e 's/<\/span>//g' \
    temp1 > paroles.tsv
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
    base.tsv > temp3
sed \
    -e ':a;N;$!ba;s/<\/span>\n<a/<a/g' \
    temp3 > temp4
sed \
    -e '/>&thinsp;/d' \
    -e '/>&nbsp;/d' \
    -e 's/&ensp;/ /g' \
    temp4 > temp5
LC_COLLATE=C.UTF-8 sed \
    -e 's/　/ /g' \
    -e 's/\(.*>\)\(.*\)\(<a.*>\)\(（リンク）\)\(.*\)/\1\3\2\5/' \
    -e 's/\(.*>やまびこ通信.*バックナンバー<.*\)$/\n# \1\n/' \
    -e 's/\(.*>[0-9]*年[0-9]*月号<.*\)$/- \1/' \
    -e 's/\(.*>やまびこ通信[0-9]*年[0-9]*月号<.*\)$/\n# \1\n/' \
    -e 's/\(.*月活動報告<.*\)$/\n## \1\n/' \
    -e 's/\(.*月活動予定<.*\)$/\n## \1\n/' \
    -e 's/\(.*>録音図書.*作成<.*\)$/\n## \1\n/' \
    -e 's/\(.*>対面音訳<.*\)$/\n## \1\n/' \
    -e 's/\(.*十条台句会.*\)$/\n## \1\n/' \
    -e 's/\(新入会員.*一言\)$/\n## \1\n/' \
    -e 's/\(.*try!!<.*\)$/\n## \1\n/' \
    -e 's/\(.*月の答え<.*\)$/\n### \1\n/' \
    -e 's/SILENT<（\(カット\)\([0-9]*\)）>SILENT/<img class=\"migi\" src=\"media\/'$2'\/cut\2\.png" alt=\"\1\2\" \/>/' \
    -e 's/｜\(.*\)SILENT< *(\([ぁ-ゟ゠ァ-ヿ]*\)) *>SILENT/<ruby>\1<rt>(\2)<\/rt><\/ruby>/g' \
    -e 's/>\(.*\)SILENT< *(\([ぁ-ゟ゠ァ-ヿ]*\)) *>SILENT/><ruby>\1<rt>(\2)<\/rt><\/ruby>/g' \
    -e 's/SILENT<\(.*\)>SILENT/\1/g' \
    temp5 >> ../$2.md
# remove temp files
#rm *.tsv temp[0-9]
cd sounds
../../wav2mp3ogg.sh
cd -
mkdir -p ../media/$2
cp -i sounds/*.mp3 ../media/$2
cp -i sounds/*.ogg ../media/$2
cd ..

