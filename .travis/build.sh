#!/bin/bash

set -e

if [[ $TRAVIS_OS_NAME == 'osx' ]]; then
    # Configure qbs
    qbs setup-toolchains --detect
    qbs setup-qt /usr/local/opt/qt/bin/qmake travis-qt5
    qbs config profiles.travis-qt5.baseProfile xcode-macosx-x86_64
    qbs config preferences.qbsSearchPaths $(pwd)/fluid/qbs/shared

    # Build and install Fluid
    cd fluid
    sudo qbs -d build -j $(sysctl -n hw.ncpu) profile:travis-qt5 modules.qbs.installRoot:/usr/local modules.lirideployment.prefix:/opt/qt modules.lirideployment.qmlDir:/opt/qt/qml project.withDocumentation:false project.withDemo:false
    sudo rm -fr build

    # Build app
    cd ../
    qbs -d build -j $(sysctl -n hw.ncpu) profile:travis-qt5 project.withFluid:false
else
    # Configure qbs
    qbs setup-toolchains --type gcc /usr/bin/g++ gcc
    qbs setup-qt $(which qmake) travis-qt5
    qbs config profiles.travis-qt5.baseProfile gcc
    qbs config preferences.qbsSearchPaths $(pwd)/fluid/qbs/shared

    # Build and install Fluid
    cd fluid
    sudo $(which qbs) -d build -j $(nproc) profile:travis-qt5 modules.qbs.installRoot:/ modules.lirideployment.prefix:/opt/qt510 modules.lirideployment.qmlDir:/opt/qt510/qml project.withDocumentation:false project.withDemo:false
    sudo rm -fr build

    # Build and install app
    cd ../
    mkdir -p appdir
    qbs -d build -j $(nproc) profile:travis-qt5 project.withFluid:false modules.qbs.installRoot:appdir modules.lirideployment.prefix:/usr
fi
