cmake_minimum_required(VERSION 3.20)

project(scintilla
    VERSION 5.5.0
    DESCRIPTION "A free source code editing component"
    LANGUAGES CXX
)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

include(scintilla-qt.cmake)
