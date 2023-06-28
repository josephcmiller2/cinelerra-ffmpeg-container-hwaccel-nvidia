#!/bin/bash

CPATH=$(realpath $(dirname "$0"))

function usage() {
    print -e "\n\n\t$0\n"
}

function preprocess_dir() {
    for infile in *.mp4; do
        outfile="${infile%.mp4}.mov"
        if [[ "$infile" == *"output"* ]] || [[ "$infile" == *"compilation"* ]] || [[ "$infile" == *"clip"* ]] || [[ "$infile" == *"test"* ]]; then
            echo "Skipping ${infile}"
        else
            echo "Converting ${infile} to ${outfile}"
            vid-preprocess.sh "${infile}" "${outfile}"
            if [[ $? -eq 0 ]]; then
                rm -f "${infile}"
            fi
        fi
    done
}

function main() {

    DIR=`pwd`

    # Preprocess the current dir frist
    preprocess_dir

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

