#!/bin/bash

sudo apt-get install build-essential git cmake
sudo apt-get install automakelibpulse-dev
sudo apt-get install libgtk-3-dev freeglut3 freeglut3-dev

cd ~/Dev
git clone https://github.com/pothosware/SoapySDR.git ./SoapySDR
cd SoapySDR
mkdir build
cd build
cmake ../
make -j4
sudo make install
sudo ldconfig


cd ~/Dev
git clone https://github.com/pothosware/SoapySDRPlay.git ./SoapySDRPlay
cd SoapySDRPlay
mkdir build
cd build
cmake ../
make
sudo make install
sudo ldconfig

cd ~/Dev
git clone https://github.com/pothosware/SoapyRemote.git ./SoapyRemote
cd SoapyRemote
mkdir build
cd build
cmake ../make
sudo make install
sudo ldconfig

cd ~/Dev
git clone https://github.com/jgaeddert/liquid-dsp.git ./liquid-dsp
cd liquid-dsp
./bootstrap.sh
CFLAGS="-march=native -O3" ./configure --enable-fftoverride
make -j4
sudo make install
sudo ldconfig

cd ~/Dev
wget https://github.com/wxWidgets/wxWidgets/releases/download/v3.1.0/wxWidgets-3.1.0.tar.bz2
tar -xvjf wxWidgets-3.1.0.tar.bz2
cd wxWidgets-3.1.0
mkdir -p ~/Dev/wxWidgets-staticlib
./autogen.sh./configure --with-opengl --disable-shared --enable-monolithic \
  --with-libjpeg --with-libtiff --with-libpng --with-zlib --disable-sdltest \
  --enable-unicode--enable-display --enable-propgrid --disable-webkit \
  --disable-webview--disable-webviewwebkit \
  --prefix=`echo ~/Dev/wxWidgets-staticlib` CXXFLAGS="-std=c++0x"
make -j4
make install

cd ~/Dev
git clone https://github.com/cjcliffe/CubicSDR.git ./CubicSDR
cd CubicSDR
mkdir build
cd build
cmake ../ -DCMAKE_BUILD_TYPE=Release \
      -DwxWidgets_CONFIG_EXECUTABLE=~/Dev/wxWidgets-staticlib/bin/wx-config
make
sudo make install
