#!/bin/bash


function usage() {
    echo -e "\n\tUsage: $0 [--deint] <input_file> <output_file>\n"
    echo "Options:"
    echo "  --deint       Enable deinterlacing (uses yadif filter)"
    echo ""
    echo "Note: The input file must exist and the output file must be specified.\n"
}

function check_options() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --deint)
                DECODE_FILTERS="-vf yadif"
                shift
                ;;
            *)
                break
                ;;
        esac
    done

    # Set input and output files
    INPUT="$1"
    OUTPUT="$2"

    if [[ ! -f "${INPUT}" ]] || [[ "${OUTPUT}" == "" ]]; then
        usage
        exit 1
    fi
}


function main() {

    DECODE_ACCEL="-hwaccel cuda -hwaccel_output_format cuda -extra_hw_frames 16"
    #DECODE_FILTERS="-vf yadif"
    VIDENCODE_OPTIONS="-profile:v main"

    check_options "$@"

    # The following may increase quality/compression at the expense of significant perfomance decrease
    #VIDENCODE_OPTIONS="${VIDENCODE_OPTIONS} -tune:v hq"

    time ffmpeg -threads 1 -y ${DECODE_ACCEL} -i "${INPUT}" ${DECODE_FILTERS} -c:a aac -c:v h264_nvenc ${VIDENCODE_OPTIONS} -rc:v vbr -cq:v 19 -movflags +faststart "${OUTPUT}"
    exit $?
}

main "$@"


