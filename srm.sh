#!/bin/bash


help() {

    echo "Usage: srm.sh [OPTION]... [FILE]..."
    echo "Safe removing files from the file system"

}

# Check if trash directory exists
trashDirectory="$HOME/.local/share/Trash"
currentDirectory=$(pwd)
option=$1


if [ ! -d $trashDirectory ]; then
    echo "Trash directory does not exist"
    echo "Creating trash directory"
    mkdir -p $trashDirectory
    mkdir -p "$trashDirectory/files"
    mkdir -p "$trashDirectory/info"
    echo "Trash directory is created"
fi



while getopts ':hs:' option; do
  case "$option" in
    h) 
        help
       exit
       ;;
    s) seed=$OPTARG
       ;;
    :) printf "missing argument for -%s\n" "$OPTARG" >&2
       exit 1
       ;;
   \?) printf "illegal option: -%s\n" "$OPTARG" >&2
       exit 1
       ;;
  esac
done

# Safe files removing (move to trash)
echo $trashDirectory
    while (( $# )); do
        if [[ -f $1 ]]; then
            echo "Removing $1"
            echo "Moving $1 to $trashDirectory/files"
            touch "$trashDirectory/info/$1.trashinfo"
            echo "[Trash Info]" >> "$trashDirectory/info/$1.trashinfo"
            echo "Path:$currentDirectory/$1" >> "$trashDirectory/info/$1.trashinfo"
            date=$(date +"%Y-%m-%dT%H:%M:%S")
            echo "DeletionDate: $date" >> "$trashDirectory/info/$1.trashinfo"

            mv $1 "$trashDirectory/files"
            # rm $1
        else
            echo "$1 is not a file"
        fi
        shift
    done



