#!/bin/bash

for i in *.pre
	do
	sed \
	-e 'y/ＡＢＣＤＥＦＧＨＩＪＫＬＭＮＯＰＱＲＳＴＵＶＷＸＹＺａｂｃｄｅｆｇｈｉｊｋｌｍｎｏｐｑｒｓｔｕｖｗｘｙｚ０１２３４５６７８９　/ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 /' \
	-e 's/ *(/（/g' \
	-e 's/) */）/g' \
	-e 's/— /-/g' \
	-e 's/: *\([^\/]\)/：\1/g' \
	-e 's/; */；/g' \
	-e 's/! */！/g' \
	-e 's/\([^\/]\)? */\1？/g' \
	-e 's/ *\[/［/g' \
	-e 's/\] */］/g' \
	-e 's/№/No\./g' \
	-e 'y/“"/""/' \
	$i > $i-temp
	LC_COLLATE=C.UTF-8 sed \
	-e 's/（ *）/ (　　　) /g' \
	-e 's/\([^a-zA-Z0-9)]\) *\([^a-zA-Z0-9(]\)/\1\2/g' \
	-e 's/\([ぁ-ゟ゠ァ-ヿ一-龠]\) \([ぁ-ゟ゠ァ-ヿ一-龠]\)/\1\2/g' \
	-e 's/（\([ぁ-ゟ゠ァ-ヿ]*\)）/ (\1) /g' \
	-e 's/（\([a-zA-Z0-9 ,\.]*\)）/ (\1) /g' \
	-e 's/y！！/y!!/g' \
	-e 's/\(このサイトについてはこちらへ\)/\1（リンク）/g' \
	-e 's/★\([0-9]*\) */（カット\1）/g' \
	-e 's/Ⅰ/I. /g' \
	-e 's/Ⅱ/II. /g' \
	-e 's/Ⅲ/III. /g' \
	-e 's/Ⅳ/IV. /g' \
	-e 's/Ⅴ/V. /g' \
	-e 's/Ⅵ/VI. /g' \
	-e 's/Ⅶ/VII. /g' \
	-e 's/Ⅷ/VIII. /g' \
	-e 's/Ⅸ/IX. /g' \
	-e 's/Ⅹ/X. /g' \
	-e 's/Ⅺ/XI. /g' \
	-e 's/Ⅻ/XII. /g' \
	-e 's/ⅰ/i. /g' \
	-e 's/ⅱ/ii. /g' \
	-e 's/ⅲ/iii. /g' \
	-e 's/ⅳ/iv. /g' \
	-e 's/ⅴ/v. /g' \
	-e 's/ⅵ/vi. /g' \
	-e 's/ⅶ/vii. /g' \
	-e 's/ⅷ/viii. /g' \
	-e 's/ⅸ/ix. /g' \
	-e 's/ⅹ/x. /g' \
	-e 's/ⅺ/xi. /g' \
	-e 's/ⅻ/xii. /g' \
	-e 's/⑴/ (1) /g' \
	-e 's/⑵/ (2) /g' \
	-e 's/⑶/ (3) /g' \
	-e 's/⑷/ (4) /g' \
	-e 's/⑸/ (5) /g' \
	-e 's/⑹/ (6) /g' \
	-e 's/⑺/ (7) /g' \
	-e 's/⑻/ (8) /g' \
	-e 's/⑼/ (9) /g' \
	-e 's/⑽/ (10) /g' \
	-e 's/⑾/ (11) /g' \
	-e 's/⑿/ (12) /g' \
	-e 's/⒀/ (13) /g' \
	-e 's/⒁/ (14) /g' \
	-e 's/⒂/ (15) /g' \
	-e 's/⒃/ (16) /g' \
	-e 's/⒄/ (17) /g' \
	-e 's/⒅/ (18) /g' \
	-e 's/⒆/ (19) /g' \
	-e 's/⒇/ (20) /g' \
	-e 's/．/\. /g' \
	$i-temp > $i-temp2
	sed \
	-e 's/^ *//' \
	-e 's/ *$//' \
	$i-temp2 > $i.txt
diff $i $i.txt > modi-$i.diff
	if [ -s modi-$i.diff ]; then
  # 1バイトでも中身があれば何もしない
		:
	else
  # 0バイトだったら消す
		rm modi-$i.diff
	fi
	rm $i-temp*
done
