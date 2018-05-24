#!/bin/bash

declare -a arr=("_tusin" "_info")
for i in "${arr[@]}"
do
  cd $i
    for j in *
      do
        sed \
          -e 's/^layout: .*/layout: print/' \
        $j > ../_p/$j
      done
  cd -
done
echo '---' > _p/index.md
echo 'layout: print' >> _p/index.md
echo 'title: 音訳グループ やまびこ' >> _p/index.md
echo '---' >> _p/index.md
echo '<h1 class="project-name" id="logotitle">音訳グループ やまびこ</h1>' >> _p/index.md
echo '' >> _p/index.md
sed -n '/##/,$p' README.md >> _p/index.md
