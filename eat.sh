#!/bin/bash

# Minimum file size (in bytes) for correct entropy reading
# (to account for archiver's headers and such)
minimum_file_size=1000

is_fast=n
is_best=n
use_bzip2=n
gzip_flags=""
bzip2_flags=""


show_help ()
{
    echo ""
    echo "Entropy Analyzer Tool (EAT)"
    echo "---------------------------"
    echo ""
    echo "This tool analyzes file entropy by compressing it using gzip or bzip2"
    echo "compression algorithms and shows the file size percentage after"
    echo "compression from original file size."
    echo ""
    echo "For example, if you have file some_document.txt which shows 16% - this"
    echo "means that the size of some_document.txt after compression is only 16% from"
    echo "original file size."
    echo ""
    echo "Basically, if file can't be compressed much - it has a high entropy"
    echo "and if the compressed size is much smaller than the original - the"
    echo "entropy is pretty low."
    echo ""
}


show_usage ()
{
    echo "Usage: ./eat.sh [options] <filename> [filename...]"
    echo "Options:"
    echo "  -h | --help    - Show help"
    echo "  -v | --version - Show version"
    echo "  --bzip2 - Use bzip2 compression (default is gzip)"
    echo "  --fast  - Lowest compression level"
    echo "  --best  - Highest compression level"
    echo ""
    echo "Note: options should go before files"
    echo ""
}


version ()
{
    echo "Entropy Analyzer Tool (EAT) v0.1"
    echo "Author: Phil Levchenko <phil.levchenko@gmail.com>"
    echo ""
}


while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -v|--version)
    version
    exit
    ;;
    -h|--help)
    show_help
    show_usage
    exit
    ;;
    -f|--fast)
    is_fast=y
    ;;
    -b|--best)
    is_best=y
    ;;
    --bzip2)
    use_bzip2=y
    ;;
    *)
        break
    ;;
esac
shift # past argument or value
done

if [[ $# -lt 1 ]]; then
    echo "Error: not enough arguments!"
    show_usage
    exit 1
fi

if [[ $is_fast == "y" && $is_best == "y" ]]; then
    echo "Error: can't use both --fast and --best at the same time!"
    exit 1
fi

if [[ $is_fast == "y" ]]; then
    gzip_flags="--fast"
    bzip2_flags="--fast"
fi

if [[ $is_best == "y" ]]; then
    gzip_flags="--best"
    bzip2_flags="--best"
fi


get_compressed_size ()
{
    if [[ $use_bzip2 == "y" ]]; then
        bzip2 $bzip2_flags -c $1 | wc -c
    else
        gzip $gzip_flags -c $1 | wc -c
    fi
}


calculate_entropy ()
{
    size_uncompressed_bytes=$(wc -c < $1)
    size_compressed_bytes=$(get_compressed_size $1)

    echo "$(( $size_compressed_bytes * 100 / $size_uncompressed_bytes ))% $1"
    if [[ $size_uncompressed_bytes < $minimum_file_size ]]; then
        echo "Warning: the file size is too small to precisely tell the entropy"
    fi
}


for file in $@; do
    if [ ! -e "$file" ]; then
        echo "Error: \"$1\" does not exist!"
        exit 1
    fi
    calculate_entropy "$file"
done
