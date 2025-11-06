cmake_minimum_required(VERSION 3.10)
project(NewtonFractal)

set(CMAKE_CXX_STANDARD 20)

set(ISPC_EXECUTABLE "C:/Users/Aleksandar/Downloads/ispc-trunk-windows/bin/ispc.exe")

set(ISPC_SOURCE ${CMAKE_SOURCE_DIR}/newton_fractal.ispc)
set(ISPC_OBJECT ${CMAKE_BINARY_DIR}/newton_fractal_ispc.obj)
set(ISPC_HEADER ${CMAKE_BINARY_DIR}/newton_fractal_ispc.h)

add_custom_command(
        OUTPUT ${ISPC_OBJECT} ${ISPC_HEADER}
        COMMAND ${ISPC_EXECUTABLE} ${ISPC_SOURCE} -o ${ISPC_OBJECT} -h ${ISPC_HEADER}
        DEPENDS ${ISPC_SOURCE}
        COMMENT "Compiling ISPC"
)

add_executable(NewtonFractal main.cpp ${ISPC_OBJECT})

include_directories(${CMAKE_BINARY_DIR})
