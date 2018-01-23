#!/usr/bin/env bash

rm -rf /Code/rockscript/rockscript-httpfiles/src/main/resources/http/docs/*

cd /Code/rockscript.github.io/docs
cp -r css fonts img js /Code/rockscript/rockscript-httpfiles/src/main/resources/http/docs
for file in *
do
  if [ ! -d "$file" ]; then
    fileName=${file%.md}
    fileNameHtml=${fileName}.html
    echo "http://localhost:5000/$fileName --> /Code/rockscript/rockscript-httpfiles/src/main/resources/http/docs/$fileNameHtml"
    curl -s http://localhost:5000/docs/$fileName > /Code/rockscript/rockscript-httpfiles/src/main/resources/http/docs/$fileNameHtml
  fi
done
