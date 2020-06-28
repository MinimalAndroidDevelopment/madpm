#!/bin/sh

SECTION=1

depart(){
    LINK=""
    case $1 in
        source=*)
            LINK=$(echo $1 | cut -d "=" -f 2)
            PKGNAME=$(echo $LINK | rev | cut -d "/" -f1 | rev)
            PKGDIR=$(echo $PKGNAME | rev | cut -c 5- | rev)

            echo "Downloading: [$LINK]"

            wget -P $HOME/.pkgs $LINK
            unzip $HOME/.pkgs/$PKGNAME -d $HOME/.pkgs/$PKGDIR
            cp $HOME/.pkgs/$PKGDIR/classes.jar $HOME/.pkgs
            mv $HOME/.pkgs/classes.jar $HOME/.pkgs/$PKGDIR.jar
            ln -s $HOME/.pkgs/$PKGDIR.jar libs/
            ;;
        depends=*)
            #echo "depends"
            ;;
        *)
            #echo "remain same item"
            ;;
    esac
}

resolve_dependencies () {
    DEPFILE=$HOME/.madpkgs/$1
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
    if [ ! -d "$HOME/.madpkgs" ]; then
        echo "Seems madpkgs doesn't exists on your machine. Please grab it from here: https://github.com/MinimalAndroidDevelopment/madpkgs"
        exit
    fi
    if [ ! -d "$HOME/.pkgs" ]; then
        mkdir -p $HOME/.pkgs;
    fi
    while read line; do
        resolve_dependencies $line
    done < $FILE
else
    echo "There's no $FILE at the root of your project. Please add it!"
fi

#echo $line
#echo $1
#[ "${1%${1#?}}"x = 'sourcex' ] && echo yes
#[ "${1#\#}"x != "${1}x" ] && echo yes
#if [ $1 = source* ]; then
#    echo "hi"
#fi
#curl $LINK --output /home/linarcx/.madpkgs/
#PUREPKGNAME=$(echo ${PKGNAME::-4})

#remove_chars(){
#    var=$1
#    size=${#var}
#    echo ${var:0:size-4}
#}
