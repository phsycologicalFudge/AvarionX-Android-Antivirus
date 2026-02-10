cmake_minimum_required(VERSION 3.14)
project(runner LANGUAGES CXX)

# Define the application target. To change its name, change BINARY_NAME in the
# top-level CMakeLists.txt, not the value here, or `flutter run` will no longer
# work.
#
# Any new source files that you add to the application should be added here.
add_executable(${BINARY_NAME} WIN32
  "flutter_window.cpp"
  "main.cpp"
  "utils.cpp"
  "win32_window.cpp"
  "${FLUTTER_MANAGED_DIR}/generated_plugin_registrant.cc"
  "Runner.rc"
  "runner.exe.manifest"
)

# Apply the standard set of build settings. This can be removed for applications
# that need different build settings.
apply_standard_settings(${BINARY_NAME})

# Add preprocessor definitions for the build version.
target_compile_definitions(${BINARY_NAME} PRIVATE "FLUTTER_VERSION=\"${FLUTTER_VERSION}\"")
target_compile_definitions(${BINARY_NAME} PRIVATE "FLUTTER_VERSION_MAJOR=${FLUTTER_VERSION_MAJOR}")
target_compile_definitions(${BINARY_NAME} PRIVATE "FLUTTER_VERSION_MINOR=${FLUTTER_VERSION_MINOR}")
target_compile_definitions(${BINARY_NAME} PRIVATE "FLUTTER_VERSION_PATCH=${FLUTTER_VERSION_PATCH}")
target_compile_definitions(${BINARY_NAME} PRIVATE "FLUTTER_VERSION_BUILD=${FLUTTER_VERSION_BUILD}")

# Disable Windows macros that collide with C++ standard library functions.
target_compile_definitions(${BINARY_NAME} PRIVATE "NOMINMAX")

# Add dependency libraries and include directories. Add any application-specific
# dependencies here.
target_link_libraries(${BINARY_NAME} PRIVATE flutter flutter_wrapper_app)
target_link_libraries(${BINARY_NAME} PRIVATE "dwmapi.lib")
target_include_directories(${BINARY_NAME} PRIVATE "${CMAKE_SOURCE_DIR}")

# Run the Flutter tool portions of the build. This must not be removed.
add_dependencies(${BINARY_NAME} flutter_assemble)

set(VX_ENGINE_DLL
        "${CMAKE_SOURCE_DIR}/../engine/windows/vx_titanium.dll"
)

set(RTP_MODULE_EXE
        "${CMAKE_SOURCE_DIR}/../rtp-module/compiled/rtpModule.exe"
)

set(CSAV_ENGINE_EXE
        "${CMAKE_SOURCE_DIR}/../rtp-module/compiled/csav.exe"
)

set(VX_DEFS_DIR
        "${CMAKE_SOURCE_DIR}/../assets/defs"
)

if(NOT EXISTS "${RTP_MODULE_EXE}")
    message(FATAL_ERROR "Missing RTP module: ${RTP_MODULE_EXE}")
endif()

if(NOT EXISTS "${CSAV_ENGINE_EXE}")
    message(FATAL_ERROR "Missing csav.exe: ${CSAV_ENGINE_EXE}")
endif()

if(NOT EXISTS "${VX_ENGINE_DLL}")
    message(FATAL_ERROR "Missing vx_titanium.dll: ${VX_ENGINE_DLL}")
endif()

if(NOT EXISTS "${VX_DEFS_DIR}")
    message(FATAL_ERROR "Missing defs dir: ${VX_DEFS_DIR}")
endif()

add_custom_command(TARGET ${BINARY_NAME} POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
        "${RTP_MODULE_EXE}"
        "$<TARGET_FILE_DIR:${BINARY_NAME}>/rtpModule.exe"
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
        "${CSAV_ENGINE_EXE}"
        "$<TARGET_FILE_DIR:${BINARY_NAME}>/csav.exe"
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
        "${VX_ENGINE_DLL}"
        "$<TARGET_FILE_DIR:${BINARY_NAME}>/vx_titanium.dll"
        COMMAND ${CMAKE_COMMAND} -E make_directory
        "$<TARGET_FILE_DIR:${BINARY_NAME}>/assets/defs"
        COMMAND ${CMAKE_COMMAND} -E copy_directory
        "${VX_DEFS_DIR}"
        "$<TARGET_FILE_DIR:${BINARY_NAME}>/assets/defs"
)
