#!/bin/bash


for i in index*.md
do
  echo '---' > p/$i
  echo 'layout: print_noindex' >> p/$i
  if [[ $i == 'index.md' ]]; then
    echo 'title: 音訳グループ やまびこ' >> p/$i
  elif [[ $i == 'index-fra.md' ]]; then
    echo 'title: Yamabiko le groupe des aides vocaux' >> p/$i
  elif [[ $i == 'index-eng.md' ]]; then
    echo 'title: The Voice Helpers&apos; Group Yamabiko' >> p/$i
  elif [[ $i == 'index-zho.md' ]]; then
    echo 'title: 音译团体Yamabiko' >> p/$i
  fi
  sed -n '/docid: /p' $i >> p/$i
  sed -n '/lang: /p' $i >> p/$i
  sed -n '/translator: /p' $i >> p/$i
  sed -n '/date: /p' $i >> p/$i
  sed -n '/oto: /p' $i >> p/$i
  echo '---' >> p/$i
  echo '' >> p/$i
  if [[ $i == 'index.md' ]]; then
    echo '<img class="fullw" src="media/index/logo-w2color.png" alt="音訳グループ やまびこ" />' >> p/$i
  elif [[ $i == 'index-fra.md' ]]; then
    echo '<img class="fullw" src="media/index/logo-w2color.png" alt="Yamabiko le groupe des aides vocaux" />' >> p/$i
  elif [[ $i == 'index-eng.md' ]]; then
    echo '<img class="fullw" src="media/index/logo-w2color.png" alt="The Voice Helpers&apos; Group Yamabiko" />' >> p/$i
  elif [[ $i == 'index-zho.md' ]]; then
    echo '<img class="fullw" src="media/index/logo-w2color.png" alt="音译团体Yamabiko" />' >> p/$i
  fi
  echo '' >> p/$i
  LC_COLLATE=C.UTF-8 sed \
  -e 's/今お聞きの声は/ホームページの声は/' \
  -e 's/href=\"\(tusin[0-9]*\.html\)/href=\"\.\/p\/\1/g' \
  -e 's/io\/bn/io\/p\/bn/g' \
  -e 's/href=\"bn/href=\"\.\/p\/bn/g' \
  -e 's/<img src=\"media\/Speaker_Icon_gray\.png\" srcset=\"media\/Speaker_Icon_gray\.svg\" alt=\"音声付き\" class=\"gyo\" \/>//g' \
  $i > temp
  sed -n '/##/,$p' temp >> p/$i
  rm temp
done

