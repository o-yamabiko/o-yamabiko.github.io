#!/bin/bash

cd _tusin
for i in *
  do
    sed \
      -e 's/^layout: .*/layout: print/' \
      $i > ../_p/$i
  done
cd -
