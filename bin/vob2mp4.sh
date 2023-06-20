#!/bin/bash

INPUT="$1"
OUTPUT="$2"

DECODE_ACCEL="-hwaccel cuda -hwaccel_output_format cuda -extra_hw_frames 16"
#DECODE_FILTERS="-vf yadif"
VIDENCODE_OPTIONS="-profile:v main"

# The following may increase quality/compression at the expense of significant perfomance decrease
#VIDENCODE_OPTIONS="${VIDENCODE_OPTIONS} -tune:v hq"

time ffmpeg -threads 1 -y ${DECODE_ACCEL} -i "${INPUT}" ${DECODE_FILTERS} -c:a aac -c:v h264_nvenc ${VIDENCODE_OPTIONS} -rc:v vbr -cq:v 19 -movflags +faststart "${OUTPUT}"
