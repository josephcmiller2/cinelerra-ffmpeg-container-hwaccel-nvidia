#!/bin/bash

CONTAINER_OPTS="-movflags +faststart"
VIDENCODE_OPTIONS="-profile:v main"

# The following may increase quality/compression at the expense of significant perfomance decrease
#VIDENCODE_OPTIONS="${VIDENCODE_OPTIONS} -tune:v hq"

# The factor to multiply the input bitrate to produce the output bitrate in order to achieve a low-loss conversion without specifying QP
VIDENCODE_BITRATE_FACTOR=2.5

DECODE_ACCEL="-hwaccel cuda -hwaccel_output_format cuda -extra_hw_frames 8"

VIDENCODE_BITRATE="3M"

INPUT="compile.txt"
OUTPUT="compilation.mp4"

function compile_vids() {

    NUM_VIDS=$(find . -maxdepth 1 -name 'clip-*.mp4' | wc -l)

    if [[ $NUM_VIDS -gt 0 ]]; then

        echo "Creating compilation in ${PWD}"

        rm -f "${INPUT}"
        for f in ./clip*.mp4; do
            echo "Adding ${f} to compilation..."
            echo "file '$f'" >> "${INPUT}"
        done

        time ffmpeg -f concat -safe 0 -threads 1 -y ${DECODE_ACCEL} -i "${INPUT}" -c copy ${CONTAINER_OPTS} "${OUTPUT}"
        return $?
    fi

    return 0
}

function main() {

    compile_vids
    if [[ $? -ne 0 ]]; then
        echo "ERROR! There was a problem creating the compilation!"
        exit 1
    fi

    for file in *; do
        if [[ -d "${file}" ]]; then
            DIR=$(pwd)
            cd "${file}"
            compile_vids

            if [[ $? -ne 0 ]]; then
                echo "ERROR! There was a problem creating the compilation!"
                exit 1
            fi

            cd "${DIR}"
        fi
    done

}

main



