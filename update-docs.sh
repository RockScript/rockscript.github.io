#!/usr/bin/env bash

rm -rf /Code/rockscript.github.io/docs/*
cp -R /Code/rockscript/rockscript/src/main/resources/webfiles/docs/ /Code/rockscript.github.io/docs
cd /Code/rockscript.github.io
git add .
git commit -m "Updated docs"
git push
