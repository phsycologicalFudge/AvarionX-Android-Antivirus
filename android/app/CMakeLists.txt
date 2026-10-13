cmake_minimum_required(VERSION 3.22.1)
project(axpty)

add_library(axpty SHARED src/main/cpp/ax_pty.c)
target_link_libraries(axpty android log)