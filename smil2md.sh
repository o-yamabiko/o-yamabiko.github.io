#!/bin/bash
# Ruby at a character other than the beginning of a phrase should be prefixedby ｜.
# It requires MultimediaDAISY2.02 files under directory $1 consisting of only one section. $2 is a project name.
# todo: 表の処理
# todo: CD製作時間の改行（行詰め、  入れ）
# todo: 句会１行化

YEAR="`echo $2 | sed -e 's/tusin\([0-9][0-9][0-9][0-9]\)[01][0-9]/\1/'`"
MONTH2="`echo $2 | sed -e 's/tusin[0-9][0-9][0-9][0-9]\([01][0-9]\)/\1/'`"
if [[ $MONTH2 == '0'* ]]; then
  MONTH1="`echo $MONTH2 | sed -e 's/0\([0-9]\)/\1/'`"
else
  MONTH1=$MONTH2
fi

# create base md
echo '---' > $2.md
echo 'docid: '$2 >> $2.md

# if index
if [[ $2 = index* ]] || [[ $2 = test* ]] ; then
  if [[ $2 != index-* ]]; then
    echo 'lang: '`sed s/index-// $2` >> $2.md
  fi
  echo 'date: '`date +%Y-%m-%dT%TZ` >> $2.md
  echo 'oto: '$2'/sound0001' >> $2.md
else
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
fi

echo '---' >> $2.md

# go to working dir
cd $1
# extract begin-end time
sed \
    -e 's/^.* id=\"\([a-zA-Z0-9_]*\)\".*npt=\([0-9\.]*\)s.*npt=\([0-9\.]*\)s.*/\2\t\3\t\1\t/' \
    -e '/ *</d' \
    -e 's/<\/*b>//g' \
    mrii0001.smil > begin-end.tsv
# extract paroles
LC_COLLATE=C.UTF-8 sed \
    -e 's/<span class=\"infty_silent\">\([^<]*\)<\/span>/\1/g' \
    -e 's/\(ケス\)\(<span[^>]*>\)/\2\1/g' \
    -e 's/\(<\/span>\)\(スケ\)/\2\1/g' \
    -e 's/<\/span>/{endspan}/g' \
    -e 's/\r//' \
    index.html > temp0
LC_COLLATE=C.UTF-8 sed \
    -e 's/<p align=\"right\" style=\"text-align:right;\">\(<span[^>]*>\)/\1classhaigo/g' \
    -e 's/<p>//' \
    -e 's/\(<[^>]*>\)<\/p>/ppp\1/g' \
    -e 's/\({endspan}\)<\/p>/ppp\1/g' \
    -e 's/\(_+-[^+]*+-_\)\(<span id[^>]*>\)/\2\1/g' \
    -e 's/<span class=\"infty_silent_space\">\([^{]*\){endspan}/ /g' \
    -e 's/\(_+-[^+]*+-_\)\(<span[^>]*>\)/\2\1/g' \
    -e 's/<span class=\"ja\">\([^{]*\){endspan}/\1/g' \
    -e 's/{endspan}<span id=/{endspan}\n<span id=/g' \
    -e 's/\(<span id=[^>]*>\)##\({endspan}\)\&ensp;\(<span id=[^>]*>\)Let/\1\2\n\3## Let/g' \
    -e 's/{endspan}\&ensp;<span id=/{endspan}\n<span id=/g' \
    -e 's/{endspan}\&nbsp; <span id=/{endspan}\n<span id=/g' \
    -e 's/&lt;/</g' \
    -e 's/&gt;/>/g' \
    -e 's/<h1>.*/xmrii_0001\t /' \
    -e 's/<img src=\"images\/image[0]*\([1-9]*\)\.jpg\" .*\/>/![cut\1](media\/'$2'\/cut\1.png){: .migi}/' \
    -e 's/<a\([^>]*\)>\([^<]*\)\(<span[^>]*>\)/\3\1((\2/g' \
    -e 's/\({endspan}\)\([^<]*\)<\/a>/))\1\2/g' \
    temp0 > temp1
#    -e 's/<span class=\"infty_silent\">\([^{]*\){endspan}/_+-\1+-_/g' \
#    -e 's/\({endspan}\)<span class=\"infty_silent\">\([^{]*\){endspan}/_+-\2+-_\1/g' \
#    -e 's/<a \(href=\"[^\"]*\"\)>\(<span id=[^>]*>\)\([^{]*\)\({endspan}\)<\/a>/\2\1 text=\"\3\"\4/g' \

LC_COLLATE=C.UTF-8 sed \
    -e 's/.*_+-\(.*blockquote.*\)+-_.*/\1/' \
    -e 's/_+-\(#*\)+-_\(<span id=\"[a-zA-Z0-9_]*\">\)/\2\1/' \
    -e 's/_+-\(ケス\)+-_\(<span id=\"[a-zA-Z0-9_]*\">\)/\2\1/' \
    -e 's/\({endspan}\)_+-\(|:---|---:|\)+-_/\2\1/' \
    -e 's/\({endspan}\)_+-\(（カット[0-9]*）\)+-_/\2\1/' \
    -e 's/\({endspan}\)\( *_+-[^+]*+-_ *\)/\2\1/g' \
    -e 's/<span id=\"\([a-zA-Z0-9_]*\)\">\([^{]*\){endspan}/\1\t\2\n/g' \
    temp1 > temp1a
LC_COLLATE=C.UTF-8 sed \
    -e 's/\(<rp>(<\/rp><rt>（<\/rt><rp>)<\/rp>\)\([ぁ-ゟ゠ァ-ヿ　（）]*\)<rp>(<\/rp><rt>）<\/rt><rp>)<\/rp>/\2\1/g' \
    -e 's/<rt>（<\/rt>/<rt>（　　　）<\/rt>/g' \
    -e 's/_+-//g' \
    -e 's/+-_//g' \
    temp1a > temp1b
csplit temp1b /blockquote.*markdown/ /月.*の答/
#    -e 's/\([^ ]*\) \([^(]*\) \((　*)\) /\1 <ruby>\2<rt>\3<\/rt><\/ruby>/g' \
#    -e 's/^\(<[^>]*>\)\([^(]*\) (\([ぁ-ゟ゠ァ-ヿ]*\)) /\1<ruby>\2<rt>\3<\/rt><\/ruby>/' \

LC_COLLATE=C.UTF-8 sed \
    -e 's/&ensp;/ /g' \
    -e 's/ppp/\n/g' \
    -e 's/<\/p>//' \
    -e 's/	//g' \
    -e '/^$/d' \
   xx01 > q.tsv
sed \
    -e 's/<span [a-zA-Z0-9_\"=]*>//g' \
    -e 's/{endspan}//g' \
    -e 's/^[ \t]*//' \
    temp1b > temp1m
sed \
    -e '/^[^x].*/d' \
    -e '/^$/d' \
    temp1m > paroles.tsv
# calculate dur-begin.tsv
awk '{
    printf("%s\t%3.3f\n", $2-$1, $1)
    }' \
    begin-end.tsv > dur-begin.tsv
# combine dur-begin.tsv and paroles.tsv
paste dur-begin.tsv paroles.tsv > base.tsv
# make span
sed \
    -e 's/\([0-9\.]*\)\t\([0-9\.]*\)\t\([a-z]*_[0-9A-Z]*\)\t\(（リンク）\)/<a href=\"\" data-dur=\"\1\" data-begin=\"\2\" id=\"\3\">\4<\/a><\/span>/' \
    -e 's/\([0-9\.]*\)\t\([0-9\.]*\)\t\([a-z]*_[0-9A-Z]*\)\t\(.*\)/<span data-dur=\"\1\" data-begin=\"\2\" id=\"\3\" markdown=\"1\">\4<\/span>/' \
    base.tsv > temp3
LC_COLLATE=C.UTF-8 sed \
    -e ':a;N;$!ba;s/<\/span>\n<a/<a/g' \
    -e ':a;N;$!ba;s/<span[^>]*>\(#*\)<\/span>\n<span/\1 <span/g' \
    -e ':a;N;$!ba;s/\(<span[^>]*>[0-9]*\.<\/span>\)\n\(<span\)/\n\1\2/g' \
    temp3 > temp4
LC_COLLATE=C.UTF-8 sed \
    -e 's/<span[^>]*>!/!/g' \
    -e 's/migi}<\/span>/migi}/g' \
    -e 's/migi}ppp<\/span>/migi}\n/g' \
    -e 's/ppp<\/span>/<\/span>\n/g' \
    -e 's/\(<span[^>]*>\)\(#*\)&ensp;/\n\2 \1/g' \
    -e 's/<span\([^>]*\)>\( href[^(]*\)((\([^)]*\)))<\/span>/<a\1\2>\3<\/a>/g' \
    -e 's/\([^月]*月.*の答.*\)/\1\n<blockquote markdown=\"1\">/' \
    -e 's/^\(<span[^>]*>定例会：<\/span>\)$/<\/blockquote>\n\n\1/' \
    -e 's/ケス[^ス]*スケ//g' \
    -e '/>ケス/d' \
    -e '/スケ</d' \
    -e 's/|:---|---:|<\/span>/<\/span>\n|:---|---:|/g' \
    -e 's/<span[^>]*> *<\/span>//g' \
    -e 's/>classhaigo/ class=\"haigo\">/g' \
    -e 's/&ensp;/ /g' \
    -e '/<span[^>]*>&thinsp;&thinsp;p*<\/span>/d' \
    temp4 > temp41

LC_COLLATE=C.UTF-8 sed \
    -e ':a;N;$!ba;s/<span[^>]*>\(#*\)<\/span>\n\(<span[^>]*>[^\n]*<\/span>\)/\1 \2\n/g' \
    -e 's/ppp<\/a>/<\/a>\n/g' \
    temp41 > temp5


if [[ $2 == 'index' ]] || [[ $2 = test* ]] ; then
cat temp5 >> ../$2.md
#LC_COLLATE=C.UTF-8 sed \
#    -e 's/　/ /g' \
#    -e 's/\(.*>\)\(.*\)\(<a.*>\)\(（リンク）\)\(.*\)/\1\3\2\5/' \
#    -e 's/<\(.*data-begin=\"0.000\".*\)$/<!--\1/' \
#    -e 's/<\(.*約[0-9]*分[0-9]*秒.*\)>$/\1-->\n/' \
#    -e 's/\(.*>注：.*\)$/\1  /' \
#    -e 's/エスケープキー/Escキー/' \
#    -e 's/ゼロキー/0キー/' \
#    -e 's/エンターキー/Enterキー/' \
#    -e 's/\(.*音声を配信しています。.*\)$/\1  /' \
#    -e 's/\(.*キーです。.*\)$/\1  /' \
#    -e 's/\(.*早口になります。.*\)$/\1  /' \
#    -e 's/\(.*ゆっくりに。.*\)$/\1  /' \
#    -e 's/\(.*巻き戻し。.*\)$/\1  /' \
#    -e 's/\(.*切り替えができます。.*\)$/\1  /' \
#    -e 's/\(.*リンク先を開くことができません。.*\)$/\1  /' \
#    -e 's/<\(.*>.*終わり.*\)>$/\n<!--\1-->\n/' \
#    -e 's/\(.*>音訳とは？.*\)$/\n## \1\n/' \
#    -e 's/\(.*音訳ボランティアグループです。.*\)$/\1\n/' \
#    -e 's/\(.*>私たちの活動.*\)$/\n## \1\n/' \
#    -e 's/\(.*>対面音訳<.*\)$/\n### \1\n/' \
#    -e 's/\(.*その場で読み上げます。.*\)$/\1\n/' \
#    -e 's/\(.*>録音図書作成<.*\)$/\n### \1\n/' \
#    -e 's/\(.*href=\"\)\(\".*著作権法第三十七条.*\)$/\1http:\/\/elaws\.e-gov\.go\.jp\/search\/elawsSearch\/elaws_search\/lsg0500\/detail?lawId=345AC0000000048\&openerCode=1\2/' \
#    -e 's/\(.*href="\)\(".*DAISY規格.*\)$/\1http:\/\/www\.dinf\.ne\.jp\/doc\/daisy\/\2/' \
#    -e 's/\(.*href="\)\(".*電子書籍の編集ソフト.*ChattyInfty3.*\)$/\1http:\/\/www\.sciaccess\.net\/jp\/ChattyInfty\/\2/' \
#    -e 's/\(.*href="\)\(".*AITalk.*\)$/\1https:\/\/www\.ai-j\.jp\/about\/\2/' \
#    -e 's/\(.*録音図書を製作します。.*\)$/\1\n/' \
#    -e 's/\(.*取り組み始めました。.*\)$/\1\n/' \
#    -e 's/\(.*レベルアップに努めています。.*\)$/\1\n/' \
#    -e 's/\(.*>その他<.*\)$/\n### \1\n/' \
#    -e 's/\(.*>やまびこ通信<.*\)$/\n## \1\n/' \
#    -e 's/\(.*月刊誌です。.*\)$/\1\n/' \
#    -e 's/\(.*href="\)\(".*最新号\)\(.*\)$/\n- \1tusin'`date +%Y%m`'\.html\2<img src=\"media\/Speaker_Icon_gray\.png\" srcset=\"media\/Speaker_Icon_gray\.svg\" alt=\"音声付き\" class=\"gyo\" \/>\3/' \
#    -e 's/\(.*href="\)\(".*バックナンバー.*\)$/- \1bn\.html\2/' \
#    -e 's/\(.*>定例会<.*\)$/\n## \1\n/' \
#    -e 's/\(.*定例会を開いています。.*\)$/\1\n/' \
#    -e 's/\(.*勉強会もしています。.*\)$/\1\n/' \
#    -e 's/\(.*お気軽にご連絡ください。.*\)$/\1\n/' \
#    -e 's/やまびこ代表大川薫/やまびこ代表 大川 薫/' \
#    -e 's/\(.*03-3910-7331）.*\)$/\1  /' \
#    -e 's/\(.*href="\)\(".*このサイトについてのお問い合わせ.*\)$/\1mailto:ymbk2016ml@gmail\.com?Subject=やまびこウェブサイトについて\2/' \
#    -e 's/\(<rp>(<\/rp><rt>（<\/rt><rp>)<\/rp>\)\([ぁ-ゟ゠ァ-ヿ　（）]*\)<rp>(<\/rp><rt>）<\/rt><rp>)<\/rp>/\2\1/g' \
#    -e 's/_+-（\(カット\)\([0-9]*\)）+-_/<img class=\"migi\" src=\"media\/'$2'\/cut\2\.png" alt=\"\1\2\" \/>/' \
#    -e 's/> </></' \
#    -e 's/_+-\([^+]*\)+-_/\1/g' \
#    temp5 >> ../$2.md
#     -e 's/｜\([^(]*\) (\([ぁ-ゟ゠ァ-ヿ]*\)) /<ruby>\1<rt>\2<\/rt><\/ruby>/g' \
#     -e 's/^\(<[^>]*>\)\([^(]*\) (\([ぁ-ゟ゠ァ-ヿ]*\)) /\1<ruby>\2<rt>\3<\/rt><\/ruby>/' \


else

LC_COLLATE=C.UTF-8 sed \
    -e '/xmrii/d' \
    -e 's/　/ /g' \
    -e 's/\(.*>\)\(.*\)\(<a.*>\)\(（リンク）\)\(.*\)/\1\3\2\5/' \
    -e 's/\(.*>やまびこ通信.*バックナンバー<.*\)$/\n# \1\n/' \
    -e 's/\(.*>[0-9]*年[0-9]*月号<.*\)$/- \1/' \
    -e 's/\([^>]*>\)\(#* \)\(.*\)$/\n\2\1\3\n/' \
    -e 's/\(.*>定例会：<.*\)$/\n\1/' \
    -e 's/\(.*中央図書館3階.*\)$/\1  /' \
    -e 's/\(.*\)やまびこ代表 *大川 *薫\(.*\)$/\1やまびこ代表 大川 薫\2  /' \
    -e 's/\(.*03-3910-7331.*\)$/\1  /' \
    -e 's/\(.*href="\)\(".*このサイトについて.*\)$/\1mailto:ymbk2016ml@gmail\.com?Subject=やまびこウェブサイトについて\2/' \
    -e 's/\(<rp>(<\/rp><rt>（<\/rt><rp>)<\/rp>\)\([ぁ-ゟ゠ァ-ヿ　（）]*\)<rp>(<\/rp><rt>）<\/rt><rp>)<\/rp>/\2\1/g' \
    -e 's/（カット\([0-9]*\)）<\/span>/<\/span>\n\n<img class=\"migi\" src=\"media\/'$2'\/cut\1\.png" alt=\"\" \/>\n/' \
    -e 's/\(<span[^>]*>No\.[0-9 ]*<\/span>\)/\1/' \
    temp5 > temp6
#    -e 's/｜\([^(]*\) (\([ぁ-ゟ゠ァ-ヿ]*\)) /<ruby>\1<rt>\2<\/rt><\/ruby>/g' \
#    -e 's/^\(<[^>]*>\)\([^(]*\) (\([ぁ-ゟ゠ァ-ヿ]*\)) /\1<ruby>\2<rt>\3<\/rt><\/ruby>/' \


    if [[ `grep "読み上げは省略" temp6` == '' ]] ; then

      csplit temp6 /月.*の答/
      cat xx00 q.tsv xx01 >> ../$2.md

    else

      csplit temp6 /読み上げは省略/
      LC_COLLATE=C.UTF-8 sed \
          -e '/読み上げは省略/d' \
          xx01 > xx01m
      cat xx00 q.tsv xx01m >> ../$2.md

    fi

fi

# remove temp files
#rm *.tsv temp[0-9]
cd sounds
../../wav2mp3ogg.sh
cd -
mkdir -p ../media/$2
cp -i sounds/*.mp3 ../media/$2
cp -i sounds/*.ogg ../media/$2
cd ..

