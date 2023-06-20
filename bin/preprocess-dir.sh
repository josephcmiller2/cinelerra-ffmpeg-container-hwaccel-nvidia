#!/bin/bash

CPATH=$(realpath $(dirname "$0"))

function usage() {
    print -e "\n\n\t$0\n"
}

function preprocess_dir() {
    for infile in *.mp4; do
        outfile="${infile%.mp4}.mov"
        if [[ "$infile" == *"output"* ]] || [[ "$infile" == *"compilation"* ]]; then
            echo "Skipping ${infile}"
        else
            echo "Converting ${infile} to ${outfile}"
        fi
    done
}

function main() {

    DIR=`pwd`

    IFS="\n"
    for file in *; do
        if [[ -d "${file}" ]]; then
            echo "Preprocessing ${file}"
            cd "${file}"
            preprocess_dir
            cd "${DIR}"
            pwd
        else
            echo "Skipping ${file}"
        fi
    done

}

main "$@"

