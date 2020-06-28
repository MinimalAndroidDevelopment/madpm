#!/bin/sh

SECTION=1

depart(){
    case $1 in
        source=*)
            echo "source"
            ;;
        depends=*)
            echo "depends"
            ;;
        *)
            echo "remain same item"
            ;;
    esac
}

resolve_dependencies () {
    DEPFILE=$HOME/madpkgs/$1
    if [ -f $DEPFILE ]; then
        while read line; do
            depart $line
        done < $DEPFILE
    else
        echo "There's no such a package in madpkgs!"
    fi
}

FILE=deps.txt
if [ -f $FILE ]; then
    if [ ! -d "$HOME/madpkgs" ]; then
        echo "Seems like madpkgs doesn't exists on your machine. Please download it from here: https://www.github.com/linarcx/madpkgs"
        exit
    fi
    while read line; do
        resolve_dependencies $line
    done < $FILE
else
    echo "There's no $FILE at the root of your project. Please add it!"
fi

#echo $line
#echo $1
#mkdir -p $HOME/madpkgs;

#[ "${1%${1#?}}"x = 'sourcex' ] && echo yes
#[ "${1#\#}"x != "${1}x" ] && echo yes
#if [ $1 = source* ]; then
#    echo "hi"
#fi
