#!/bin/bash

INPUT="$1"
OUTPUT="$2"


CONTAINER_OPTS="-movflags +faststart"
VIDENCODE_OPTIONS="-profile:v main"

# The following may increase quality/compression at the expense of significant perfomance decrease
#VIDENCODE_OPTIONS="${VIDENCODE_OPTIONS} -tune:v hq"

# The factor to multiply the input bitrate to produce the output bitrate in order to achieve a low-loss conversion without specifying QP
VIDENCODE_BITRATE_FACTOR=2.5

DECODE_ACCEL="-hwaccel cuda -hwaccel_output_format cuda -extra_hw_frames 8"

VID_FPS=$(ffprobe "${INPUT}" 2>&1 | grep 'Stream #' | grep Video | head -n 1 | perl -pe 's/^.*\s+([0-9\.]+)\s+fps.*$/$1/')
VID_FPS=$(echo "$VID_FPS 0.0" | awk '{ print $1 + $2 }')
if [[ $VID_FPS == "" ]]; then
  VID_FPS=30
fi
echo "FPS = $VID_FPS"

VID_BITRATE=$(ffprobe 'peachy_icecream 2023-06-17 15_28.mp4' 2>&1 | grep 'Stream #' | grep Video | head -n 1  | perl -pe 's/^.*\s+([0-9\.]+)\s+(kb\/s|b\/s).*$/$1/')
VID_BITRATE=$(echo "$VID_BITRATE 0"  | awk '{ print $1 + $2 }')
VID_BITRATE_UNITS=$(ffprobe 'peachy_icecream 2023-06-17 15_28.mp4' 2>&1 | grep 'Stream #' | grep Video | head -n 1  | perl -pe 's/^.*\s+([0-9\.]+)\s+(k|)b\/s.*$/$2/')
if [[ $VID_BITRATE == "" ]] || [[ $VID_BITRATE == "0" ]] ; then
  VIDENCODE_BITRATE="20M"
else
  VIDENCODE_BITRATE=$(echo "$VID_BITRATE $VIDENCODE_BITRATE_FACTOR" | awk '{ print $1 * $2 }')
  VIDENCODE_BITRATE="${VIDENCODE_BITRATE}${VID_BITRATE_UNITS}"
fi
echo "VID_BITRATE = $VID_BITRATE ${VID_BITRATE_UNITS}b/s"
echo "VIDENCODE_BITRATE = $VIDENCODE_BITRATE"

# -af aresample=async=1 # Fixes streams that have dropped audio packets
# -vysnc 1 # Fixes streams with dropped or duplicated video frames

time ffmpeg -threads 1 -y ${DECODE_ACCEL} -fflags +genpts -i "${INPUT}" -af aresample=async=1 -c:a aac -c:v h264_nvenc -vsync 1 -r ${VID_FPS} ${VIDENCODE_OPTIONS} -b:v ${VIDENCODE_BITRATE} ${CONTAINER_OPTS} "${OUTPUT}"


exit $?


