# SPDX-License-Identifier: GPL-2.0-or-later
cmake_minimum_required(VERSION 3.25)
project(plasma-stereo-wallpaper VERSION 0.1.0)
find_package(ECM 6.0 REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH})
include(KDEInstallDirs6)
include(KDECMakeSettings)
find_package(Plasma REQUIRED)
plasma_install_package(package org.sparky.stereoimage wallpapers wallpaper)
