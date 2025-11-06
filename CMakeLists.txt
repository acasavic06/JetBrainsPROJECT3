cmake_minimum_required(VERSION 3.10)
project(NewtonFractal)

set(CMAKE_CXX_STANDARD 20)

set(ISPC_EXECUTABLE "C:/Users/Aleksandar/Downloads/ispc-trunk-windows/bin/ispc.exe")

set(ISPC_SOURCE ${CMAKE_SOURCE_DIR}/newton_fractal.ispc)
set(ISPC_OBJECT ${CMAKE_BINARY_DIR}/newton_fractal_ispc.obj)
set(ISPC_HEADER ${CMAKE_BINARY_DIR}/newton_fractal_ispc.h)

add_custom_command(
        OUTPUT ${CMAKE_BINARY_DIR}/newton_fractal_ispc.obj
       COMMAND ${ISPC_EXECUTABLE} ${CMAKE_SOURCE_DIR}/newton_fractal.ispc -o ${CMAKE_BINARY_DIR}/newton_fractal_ispc.obj -h ${CMAKE_BINARY_DIR}/newton_fractal_ispc.h
        DEPENDS ${CMAKE_SOURCE_DIR}/newton_fractal.ispc
        COMMENT "Compiling ISPC"
)

add_executable(NewtonFractal main.cpp ${CMAKE_BINARY_DIR}/newton_fractal.obj)
include_directories(${CMAKE_BINARY_DIR})
