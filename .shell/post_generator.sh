#!/bin/bash
#author: Lruihao
cd ..
read -p "Please enter the article name: " postName

year=$(date +%Y)

mkdir -p ../contents/posts/year

if [ -z $postName ];then
  echo "The article name is required!"
else
  read -p "Will there be pictures in this article? [y/n]..." choice
  if [ $choice = "y" ];then
    hugo new --kind post-bundle posts/$year/$postName
  else
    hugo new posts/$year/$postName.md
  fi
fi