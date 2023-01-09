#!/usr/bin/env bash

echo "Cloning repositories"
CURRENT_PWD=$(pwd)
VCPKG_FILENAME=$1

echo $CURRENT_PWD

cd ..

echo "BabelCDB"
git clone https://github.com/ProjectIgnis/BabelCDB

echo "windbot"
git clone https://github.com/ProjectIgnis/windbot

echo "scripts"
git clone https://github.com/ProjectIgnis/CardScripts

echo "lflist"
git clone https://github.com/ProjectIgnis/LFLists

#Start by cloning edopro, Distribution, windbot and BabelCDB

echo "Installing (only Windows) - please check 'https://github.com/edo9300/edopro/wiki/1.-Prerequisites' to make sure pre-requisites are fullfilled"

echo ""
echo "Installing vcpkg"
git clone https://github.com/microsoft/vcpkg.git /c/vcpkg
cd /c/vcpkg
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "& '.\bootstrap-vcpkg.bat'"
./vcpkg.exe integrate install
./vcpkg.exe install --triplet x86-windows-static lua[cpp] libevent sqlite3 bzip2 libjpeg-turbo libpng zlib curl libgit2 fmt nlohmann-json freetype 

echo ""
echo "Copying Distribution"
cd $CURRENT_PWD
cp -r -f ../Distribution/config .
cp -r -f ../Distribution/fonts .
cp -r -f ../Distribution/expansions .
cp -r -f ../Distribution/textures .

echo ""
echo "Copying Card database"
cp -f ../BabelCDB/cards.cdb .

echo ""
echo "Copying Windbot"
cp -r ../windbot/ .
mv windbot WindBot

echo ""
echo "Copying Scripts"
cp -r ../CardScripts/ .
mv CardScripts script

echo ""
echo "Copying LFLists"
cp -r ../LFLists/ .
mv LFLists lflists



echo ""
echo "Finished copying"

echo "Installing"

echo ""
echo "Installing premake5"
cd $CURRENT_PWD
./travis/install-premake5.sh windows

echo ""
echo "Installing local dependencies"
./travis/install-local-dependencies.sh windows

echo ""
echo "Installing Prebuilt Windows libraries"
cp -r ../$VCPKG_FILENAME ./
unzip $VCPKG_FILENAME
cd $CURRENT_PWD/installed
/c/vcpkg/vcpkg.exe integrate install
cd $CURRENT_PWD

echo ""
cd $CURRENT_PWD
echo "Installing Game"
./premake5.exe vs2022 --no-direct3d

echo ""
echo "Predeploy Game"
export BUILD_CONFIG=debug
export TRAVIS_OS_NAME=windows
./travis/predeploy.sh windows
