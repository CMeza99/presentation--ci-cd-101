#!/usr/bin/env bash

#---------/---------------------\---------#
#--------|- Jekyll Post Creator -|--------#
#---------\---------------------/---------#
# Thanks to davejamesmiller for his ask function, found here:
# https://gist.github.com/davejamesmiller/1965569


# Post creator designed to remove the repetitive aspects of writing posts in Jekyll.

# Simply put the script in your site directory, edit the configs to fit your setup, and run it with:
# ./post "post title"

# What is does:
# - creates the post with the correct format of date and title
# - adds YAML front-matter (layout, title, comments (if using custom yaml comments section), date, categories)
# - opens the post file in editor chosen


########## Configs ##########

# Post layout
layout=post

# Post comments (lowercase please)
comments=true

# Post text editor
editor=vim

# Post directory
folder=_posts/

########## Program ##########

# show help with -h
if [ "$1" == "-h" ]; then
  echo "Usage: `basename $0` \"Post title\""
  exit 0
elif [ -z "$1" ]; then
  echo "Usage: `basename $0` \"Post title\""
  exit 0
fi

# Y/n ask function
function ask {
    while true; do

        if [ "${2:-}" = "true" ]; then
            prompt="Y/n"
            default=Y
        elif [ "${2:-}" = "false" ]; then
            prompt="y/N"
            default=N
        else
            prompt="y/n"
            default=
        fi

        # Ask the question
        read -p "$1 [$prompt] " REPLY

        # Default?
        if [ -z "$REPLY" ]; then
            REPLY=$default
        fi

        # Check if the reply is valid
        case "$REPLY" in
            Y*|y*) return 0 ;;
            N*|n*) return 1 ;;
        esac

    done
}

##### Variables #####

# post title
title="$1"

# convert title to filename format
# echo part replaces spaces with '-'
# awk converts it to lowercase
# sed keeps only lowercase letters and '-'
filetitle=$( echo ${1// /-} | awk '{print tolower($0)}'| sed 's/[^a-z\-]*//g')

# name of file
filename="$folder`date +%F`-$filetitle.md"
echo $filename


########## Adding to file ##########

echo "---" >> $filename
echo "layout: $layout" >> $filename
echo "title: \"$title\"" >> $filename
# if ask "Allow comments?" $comments; then
#   echo "comments: true" >> $filename
# else
#   echo "comments: false" >> $filename
# fi
echo "date: `date +%F\ %H:%M:%S`" >> $filename
# read -p "Categories: " categories
# if [ "$categories" ]; then
echo "categories: $categories" >> $filename
# fi
echo "---" >> $filename
echo >> $filename

# open in chosen editor
if [ "$editor" == "vim" ]; then
  vim + $filename
else
  $editor $filename
fi
