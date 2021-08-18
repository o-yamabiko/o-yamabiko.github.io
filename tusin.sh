#!/bin/bash

# $1 should be in the form "YYYYmm".

YEAR="`echo $1 | sed -e 's/\([0-9][0-9][0-9][0-9]\)[01][0-9]/\1/'`"
MONTH2="`echo $1 | sed -e 's/[0-9][0-9][0-9][0-9]\([01][0-9]\)/\1/'`"
if [[ $MONTH2 == '0'* ]]; then
  MONTH1="`echo $MONTH2 | sed -e 's/0\([0-9]\)/\1/'`"
else
  MONTH1=$MONTH2
fi

grep "tusin"$1 bn.list > search
	if [ -s search ]; then
  # 1バイトでも中身があれば何もしない
		:
	else
  # 0バイトだったら追加
		(echo $'- <a href="tusin'$1'.html">'$YEAR'年'$MONTH1'月号 <img src="media/Speaker_Icon_gray.png" srcset="media/Speaker_Icon_gray.svg" alt="音声付き" class="gyo" /></a>' && cat bn.list) > bn.list1 && mv bn.list1 bn.list
		echo '---' > temp.md
		echo 'layout: caymanyomi' >> temp.md
		echo 'title: やまびこ通信 バックナンバー' >> temp.md
		echo 'author: 音訳グループ やまびこ' >> temp.md
		echo 'date: '`date +%Y-%m-%dT%TZ` >> temp.md
		echo 'iro: 2679B9' >> temp.md
		echo 'gra: 95B926' >> temp.md
		echo '---' >> temp.md
		echo '' >> temp.md
		echo '# やまびこ通信 バックナンバー' >> temp.md
		echo '' >> temp.md
		echo '2017年12月号から、 ChattyInfty3で編集したAITalkの合成音声で読み上げ版の発行を始めました。 それ以前の号は紙に印刷する形で発行していました。' >> temp.md
		echo '' >> temp.md
		echo '以下は読み上げ版のリストです。' >> temp.md
		echo '' >> temp.md
		cat temp.md bn.list > ./_info/bn.md
		sed -e 's/\(tusin[0-9]*\)\.html/tusin'$1'\.html/' index.md > index.md1 && mv index.md1 index.md
		sed -e 's/\(tusin[0-9]*\)\.html/tusin'$1'\.html/' index-fra.md > index-fra.md1 && mv index-fra.md1 index-fra.md
		sed -e 's/\(tusin[0-9]*\)\.html/tusin'$1'\.html/' index-eng.md > index-eng.md1 && mv index-eng.md1 index-eng.md
		sed -e 's/\(tusin[0-9]*\)\.html/tusin'$1'\.html/' index-zho.md > index-zho.md1 && mv index-zho.md1 index-zho.md

	fi

rm search temp.md

./print.sh

