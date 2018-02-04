#!/bin/bash

if [[ $TRAVIS_OS_NAME == 'osx' ]]; then
    brew install qt5 qbs
    brew link qt5 --force
    brew link qbs --force
else
    sudo apt-get install -qq g++-7
    sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 90
    sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-7 90
    gcc --version

    sudo apt-get -y install qt510base qt510declarative qt510quickcontrols2 qt510svg qt510webengine qt510graphicaleffects qt510tools qt510script qt510qbs
    source /opt/qt510/bin/qt510-env.sh
fi
