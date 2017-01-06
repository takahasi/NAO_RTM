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
python NAO_python/NAO_python.py &> /dev/null &
(cd FloatSeqToVelocity && python FloatSeqToVelocity.py &> /dev/null) &
(cd TkJoyStick && python TkJoyStickComp.py  &> /dev/null) &
(cd CameraViewer/build/src && CameraViewerComp &> /dev/null) &

# start openrtp
openrtp &> /dev/null &

exit 0
