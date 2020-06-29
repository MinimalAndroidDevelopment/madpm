#!/bin/sh

SECTION=1

resolve_dependencies () {
    DEPFILE=$HOME/.madpkgs/$1
    if [ -f $DEPFILE ]; then
        while read line; do
            depart $line
        done < $DEPFILE
    else
        echo "$1 not found in madpkgs!"
    fi
}

split() {
    # Disable globbing.
    # This ensures that the word-splitting is safe.
    set -f

    # Store the current value of 'IFS' so we
    # can restore it later.
    old_ifs=$IFS

    # Change the field separator to what we're
    # splitting on.
    IFS=$2

    # Create an argument list splitting at each
    # occurance of '$2'.
    #
    # This is safe to disable as it just warns against
    # word-splitting which is the behavior we expect.
    # shellcheck disable=2086
    set -- $1

    # Print each list value on its own line.
    resolve_dependencies $@
    #printf '%s\n' "$@"

    # Restore the value of 'IFS'.
    IFS=$old_ifs

    # Re-enable globbing.
    set +f
}

depart(){
    LINK=""
    case $1 in
        source=*)
            LINK=$(echo $1 | cut -d "=" -f 2)
            #PKGNAME=$(echo $LINK | rev | cut -d "/" -f1 | rev)
            #PKGDIR=$(echo $PKGNAME | rev | cut -c 5- | rev)

            #echo "Downloading: [$LINK]"

            #wget -P $HOME/.pkgs $LINK
            #unzip $HOME/.pkgs/$PKGNAME -d $HOME/.pkgs/$PKGDIR
            #cp $HOME/.pkgs/$PKGDIR/classes.jar $HOME/.pkgs
            #mv $HOME/.pkgs/classes.jar $HOME/.pkgs/$PKGDIR.jar
            #ln -s $HOME/.pkgs/$PKGDIR.jar libs/
            ;;
        depends=*)
            DEPS=$(echo $1 | cut -d "=" -f 2)
            split $DEPS ";"
            #echo $DEPS
            ;;
        *)
            #echo "remain same item"
            ;;
    esac
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
