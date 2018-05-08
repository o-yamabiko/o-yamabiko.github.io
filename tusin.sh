#!/bin/bash

YEAR=`echo $1 | sed -e 's/tusin\([0-9][0-9][0-9][0-9]\)[01][0-9]/\1/'`
MONTH2=`echo $1 | sed -e 's/tusin[0-9][0-9][0-9][0-9]\([01][0-9]\)/\1/'`
if [ $MONTH2='0'* ]; then
  MONTH1=`echo $MONTH2 | sed -e 's/0\([0-9]\)/\1/'`
else
  MONTH1=$MONTH2
fi

grep $1 bn.list > search
	if [ -s search ]; then
  # 1バイトでも中身があれば何もしない
		:
	else
  # 0バイトだったら消す
		(echo '- <a href="'$1'.html">'$YEAR'年'$MONTH1'月号</a>' && cat bn.list) > bn.list1 && mv bn.list1 bn.list
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
		sed -e 's/\(tusin[0-9]*\)\.html/'$1'\.html/' README.md > README.md1 && mv README.md1 README.md

	fi

rm search temp.md

