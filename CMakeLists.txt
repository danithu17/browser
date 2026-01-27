cmake_minimum_required(VERSION 3.16)

project(AegisBrowser VERSION 1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick WebEngineQuick Widgets)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

set(SOURCE_FILES
    main.cpp
    src/WebEngineHandler.cpp
    src/WebEngineHandler.h
    resources/qml.qrc
)

add_executable(AegisBrowser WIN32 ${SOURCE_FILES})

target_link_libraries(AegisBrowser PRIVATE
    Qt6::Quick
    Qt6::WebEngineQuick
    Qt6::Widgets
)
