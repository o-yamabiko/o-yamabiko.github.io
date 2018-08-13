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
for i in index*.md
do
  echo '---' > _p/$i
  echo 'layout: print_noindex' >> _p/$i
  if [[ $i == 'index.md' ]]; then
    echo 'title: 音訳グループ やまびこ' >> _p/$i
  elif [[ $i == 'index-fra.md' ]]; then
    echo 'title: Yamabiko le groupe des aides vocaux' >> _p/$i
  elif [[ $i == 'index-eng.md' ]]; then
    echo 'title: The Voice Helpers&apos; Group Yamabiko' >> _p/$i
  elif [[ $i == 'index-zho.md' ]]; then
    echo 'title: 音译团体Yamabiko' >> _p/$i
  fi
  sed -n '/docid: /p' $i >> _p/$i
  sed -n '/lang: /p' $i >> _p/$i
  sed -n '/translator: /p' $i >> _p/$i
  sed -n '/date: /p' $i >> _p/$i
  echo '---' >> _p/$i
  if [[ $i == 'index.md' ]]; then
    echo '<img class="fullw" src="media/index/logo-w2color.png" alt="音訳グループ やまびこ" />' >> _p/$i
  elif [[ $i == 'index-fra.md' ]]; then
    echo '<img class="fullw" src="media/index/logo-w2color.png" alt="Yamabiko le groupe des aides vocaux" />' >> _p/$i
  elif [[ $i == 'index-eng.md' ]]; then
    echo '<img class="fullw" src="media/index/logo-w2color.png" alt="The Voice Helpers&apos; Group Yamabiko" />' >> _p/$i
  elif [[ $i == 'index-zho.md' ]]; then
    echo '<img class="fullw" src="media/index/logo-w2color.png" alt="音译团体Yamabiko" />' >> _p/$i
  fi
  echo '' >> _p/$i
  sed  -e 's/今お聞きの声は/ホームページの声は/' $i > temp
  sed -n '/##/,$p' temp >> _p/$i
  rm temp
done
#fra
echo '---' > _p/index-fra.md
echo 'layout: print_noindex' >> _p/index-fra.md
echo 'title: Yamabiko le groupe des aides vocaux' >> _p/index-fra.md
sed -n '/docid: /p' index-fra.md >> _p/index-fra.md
sed -n '/lang: /p' index-fra.md >> _p/index-fra.md
sed -n '/translator: /p' index-fra.md >> _p/index-fra.md
sed -n '/date: /p' index-fra.md >> _p/index-fra.md
echo '---' >> _p/index-fra.md
echo '<img class="fullw" src="media/index/logo-w2color.png" alt="Yamabiko le groupe des aides vocaux" />' >> _p/index-fra.md
echo '' >> _p/index-fra.md
sed -n '/##/,$p' index-fra.md >> _p/index-fra.md
#eng
echo '---' > _p/index-eng.md
echo 'layout: print_noindex' >> _p/index-eng.md
echo 'title: The Voice Helpers&apos; Group Yamabiko' >> _p/index-eng.md
sed -n '/docid: /p' index-eng.md >> _p/index-eng.md
sed -n '/lang: /p' index-eng.md >> _p/index-eng.md
sed -n '/translator: /p' index-eng.md >> _p/index-eng.md
sed -n '/date: /p' index-eng.md >> _p/index-eng.md
echo '---' >> _p/index-eng.md
echo '<img class="fullw" src="media/index/logo-w2color.png" alt="The Voice Helpers&apos; Group Yamabiko" />' >> _p/index-eng.md
echo '' >> _p/index-eng.md
sed -n '/##/,$p' index-eng.md >> _p/index-eng.md
#zho
echo '---' > _p/index-zho.md
echo 'layout: print_noindex' >> _p/index-zho.md
echo 'title: 音译团体Yamabiko' >> _p/index-zho.md
sed -n '/docid: /p' index-zho.md >> _p/index-zho.md
sed -n '/lang: /p' index-zho.md >> _p/index-zho.md
sed -n '/translator: /p' index-zho.md >> _p/index-zho.md
sed -n '/date: /p' index-zho.md >> _p/index-zho.md
echo '---' >> _p/index-zho.md
echo '<img class="fullw" src="media/index/logo-w2color.png" alt="音译团体Yamabiko" />' >> _p/index-zho.md
echo '' >> _p/index-zho.md
sed -n '/##/,$p' index-zho.md >> _p/index-zho.md

