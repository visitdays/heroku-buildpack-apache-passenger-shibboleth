#!/usr/bin/env bash

PASSENGER_VERSION="4.0.59"

source $(dirname "$0")/support/setup.sh

BUILD_DIR=${APP_DIR}/build/passenger

mkdir -p ${BUILD_DIR}
cd ${BUILD_DIR}

PASSENGER="passenger-${PASSENGER_VERSION}"
if [ ! -d "${PASSENGER}" ]; then
  ARCHIVE=${PASSENGER}.tar.gz
  if [ ! -f "${ARCHIVE}" ]; then
    $get http://s3.amazonaws.com/phusion-passenger/releases/${ARCHIVE}
    $get https://s3.amazonaws.com/phusion-passenger/releases/${ARCHIVE}.asc
    $verify ${ARCHIVE}.asc
  fi
  $extract ${ARCHIVE}
fi

rm -f *.tar.gz*

PREFIX=${INSTALL_DIR}/passenger

pushd ${PASSENGER}
# Passenger install script needs to be able to find Apache's apxs binary in the path
export PATH=/app/opt/apache/bin:$PATH
./bin/passenger-install-apache2-module -a --languages ruby
popd

mv ${PASSENGER} ${PREFIX}
