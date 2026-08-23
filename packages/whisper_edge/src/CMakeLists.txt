# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(whisper_edge_library VERSION 0.0.1 LANGUAGES C CXX)

set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

# Build whisper + ggml as static libs folded into the single
# libwhisper_edge.so that the Dart side dlopens.
set(BUILD_SHARED_LIBS OFF CACHE BOOL "" FORCE)
set(WHISPER_BUILD_TESTS OFF CACHE BOOL "" FORCE)
set(WHISPER_BUILD_EXAMPLES OFF CACHE BOOL "" FORCE)
set(WHISPER_BUILD_SERVER OFF CACHE BOOL "" FORCE)
set(GGML_OPENMP OFF CACHE BOOL "" FORCE)

add_subdirectory(whisper.cpp EXCLUDE_FROM_ALL)

add_library(whisper_edge SHARED
  "whisper_edge.c"
)

target_link_libraries(whisper_edge PRIVATE whisper)
target_include_directories(whisper_edge PRIVATE
  "${CMAKE_CURRENT_SOURCE_DIR}/whisper.cpp/include"
  "${CMAKE_CURRENT_SOURCE_DIR}/whisper.cpp/ggml/include"
)

set_target_properties(whisper_edge PROPERTIES
  PUBLIC_HEADER whisper_edge.h
  OUTPUT_NAME "whisper_edge"
)

target_compile_definitions(whisper_edge PUBLIC DART_SHARED_LIB)

if (ANDROID)
  # Support Android 15 16k page size
  target_link_options(whisper_edge PRIVATE "-Wl,-z,max-page-size=16384")
  target_link_libraries(whisper_edge PRIVATE log)
endif()
