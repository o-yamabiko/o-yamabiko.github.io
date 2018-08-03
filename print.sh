#!/bin/bash

declare -a arr=("_tusin" "_info")
for i in "${arr[@]}"
do
  cd $i
    for j in *
      do
        sed \
          -e 's/^layout: .*/layout: print_noindex/' \
        $j > ../_p/$j
      done
  cd -
done
echo '---' > _p/index.md
echo 'layout: print' >> _p/index.md
echo 'title: 音訳グループ やまびこ' >> _p/index.md
sed -n '/date: /p' index.md >> _p/index.md
echo '---' >> _p/index.md
echo '<img class="fullw" src="media/index/logo-w2color.png" alt="音訳グループ やまびこ" />' >> _p/index.md
echo '' >> _p/index.md
sed  -e 's/今お聞きの声は/ホームページの声は/' index.md > temp
sed -n '/##/,$p' temp >> _p/index.md
rm temp
