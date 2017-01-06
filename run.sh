#!/bin/bash
# @(#) This is xxxxxxxxxxxx.

# Checks unnecessary paramters
set -ue

####################
# GLOBAL CONSTANTS #
####################
# readonly XXX="xxx"

####################
# GLOBAL VARIABLES #
####################
# XXX="xxx"


################
# MAIN ROUTINE #
################

# start naming service
rtm-naming

# start components
./CameraViewer/build/src/CameraViewerComp &> /dev/null &
python NAO/NAO_python.py &> /dev/null &
python FloatSeqToVelocity/FloatSeqToVelocity.py &> /dev/null &
python TkJoyStick/TkJoyStickComp.py  &> /dev/null &
./CameraViewer/build/src/CameraViewerComp &> /dev/null &

# start openrtp
openrtp &> /dev/null &

exit 0
