cmake_minimum_required(VERSION 3.16)
project(start-menu)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

set(KF6_MIN_VERSION "6.0.0")
set(QT_MIN_VERSION "6.6.0")

find_package(ECM ${KF6_MIN_VERSION} REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH})

include(ECMQmlModule)
include(KDEInstallDirs)
include(KDECMakeSettings)
#include(KDECompilerSettings NO_POLICY_SCOPE)

find_package(Qt6 REQUIRED COMPONENTS Core Qml Quick DBus)
find_package(KF6 REQUIRED COMPONENTS Config)
find_package(Plasma REQUIRED)

ecm_add_qml_module(start-menu
    URI "org.dekart.start"
    GENERATE_PLUGIN_SOURCE
)

target_sources(start-menu PRIVATE
    src/start_menu.cpp
    src/start_menu.h
)

target_include_directories(start-menu PRIVATE
    src
)

target_link_libraries(start-menu PRIVATE
    Qt6::Core
    Qt6::Qml
    Qt6::Quick
    Qt6::DBus
    Plasma::Plasma
)

ecm_finalize_qml_module(start-menu DESTINATION ${KDE_INSTALL_QMLDIR})

plasma_install_package(package org.dekart.start)
