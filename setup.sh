#!/bin/bash
# @(#) This is xxxxxxxxxxxx.

# Checks unnecessary paramters
set -ue

####################
# GLOBAL CONSTANTS #
####################
# readonly XXX="xxx"
readonly PYNAOQI_VERSION=python2.7-2.1.4.13-linux64
readonly PIL_VERSION=1.1.7
readonly NAO_PORT=9559
readonly NAO_IPADDRESS=169.254.252.60

####################
# GLOBAL VARIABLES #
####################
# XXX="xxx"


# install Pnaoq-sdk-python
function install_pynaoqi() {
  # https://community.ald.softbankrobotics.com/ja/resources/software/3-python-naoqi-sdk
  readonly pynaoqi_archive=pynaoqi-${PYNAOQI_VERSION}.tar.gz
  if [ `echo $PYTHONPATH | grep pynaoqi` ]; then
    echo "already set environment parameter PYTHONPATH"
  else
    if [ -e ${pynaoqi_archive} ]; then
      tar xzf ${pynaoqi_archive}
    else
      echo "not exsit ${pynaoqi_archive} !!"
      exit 1
    fi
    echo "export PYTHONPATH=${PYTHONPATH}:$PWD/pynaoqi-${PYNAOQI_VERSION}" >> ~/.bashrc
    source ~/.bashrc
  fi

  return 0
}

# install PIL
function install_pil() {
  readonly pil_archive=PIL-${PIL_VERSION}.tar.gz
  if [ `which pilconvert.py` ]; then
    echo "already installed PIL"
  else
    sudo apt-get update
    sudo apt-get install -y --force-yes libjpeg8 libjpeg62-dev libfreetype6 libfreetype6-dev
    wget http://effbot.org/media/downloads/${pil_archive}
    tar xzf ${pil_archive}
    (cd PIL-${PIL_VERSION} && python setup.py build && sudo python setup.py install)
  fi

  return 0
}

# NAO RTC
function install_nao_rtc() {
  git clone https://github.com/ogata-lab/NAO_python
  (cd NAO_python && chmod a+x idlcompile.sh && ./idlcompile.sh)

  # Creates NAO_python.conf
  cp NAO_python/NAO_python.conf .
  # ip address : NAO_IPADDRESS
  sed -i -e "s/conf.default.ipaddress: localhost/conf.default.apaddress: ${NAO_IPADDRESS}/g" NAO_python.conf
  # port : NAO_PORT
  sed -i -e "s/conf.default.port:63812/conf.default.port: ${NAO_PORT}/g" NAO_python.conf

  # Creates rtc.conf
  readonly RTCLOG=rtc.NAO_python.log
  readonly RTCCONF=rtc.conf
  cat << EOS > $RTCCONF
corba.nameservers: localhost
naming.formats: %n.rtc
logger.enable: YES
logger.log_level: VERBOSE
logger.file_name: $RTCLOG
Humanoid.NAO_python.config_file: NAO_python.conf
EOS

  return 0
}

# CameraViewer RTC
function install_cameraviewer_rtc() {
  svn export http://svn.openrtm.org/ImageProcessing/trunk/ImageProcessing/opencv/components/CameraViewer/
  (cd CameraViewer && mkdir build && cd build && cmake .. && make)
  return 0
}

# TkJoystick
function install_tkjoystick_rtc() {
  svn export http://svn.openrtm.org/OpenRTM-aist-Python/trunk/OpenRTM-aist-Python/OpenRTM_aist/examples/TkJoyStick/
  return 0
}

# FloatSeqToVelocity
function install_floattovelocity_rtc() {
  git clone https://github.com/Nobu19800/FloatSeqToVelocity
  return 0
}

function clean_workspace() {
  rm -rf *.conf *.log
  rm -rf CameraViewer
  rm -rf NAO_python
  rm -rf TkJoyStick
  rm -rf FloatSeqToVelocity

}

################
# MAIN ROUTINE #
################

clean_workspace
install_pynaoqi
install_pil
install_nao_rtc
install_cameraviewer_rtc
install_tkjoystick_rtc
install_floattovelocity_rtc

exit 0
