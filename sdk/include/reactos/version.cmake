option(NO_REACTOS_BUILDNO "If true, disables the generation of buildno.h and version.h for each configure" OFF)

if (NOT NO_REACTOS_BUILDNO)
    string(TIMESTAMP KERNEL_VERSION_BUILD %Y%m%d UTC)
else()
    set(KERNEL_VERSION_BUILD "custom")
endif()

set(KERNEL_VERSION_MAJOR "0")
set(KERNEL_VERSION_MINOR "4")
set(KERNEL_VERSION_PATCH_LEVEL "16")
set(COPYRIGHT_YEAR "2024")

# KERNEL_VERSION_BUILD_TYPE is "dev" for Git builds
# or "RC1", "RC2", "" for releases.
set(KERNEL_VERSION_BUILD_TYPE "dev")

set(KERNEL_VERSION "${KERNEL_VERSION_MAJOR}.${KERNEL_VERSION_MINOR}.${KERNEL_VERSION_PATCH_LEVEL}-${WINARCH}")
if(NOT KERNEL_VERSION_BUILD_TYPE STREQUAL "")
    set(KERNEL_VERSION "${KERNEL_VERSION}-${KERNEL_VERSION_BUILD_TYPE}")
endif()

math(EXPR REACTOS_DLL_VERSION_MAJOR "${KERNEL_VERSION_MAJOR}+42")
set(DLL_VERSION_STR "${REACTOS_DLL_VERSION_MAJOR}.${KERNEL_VERSION_MINOR}.${KERNEL_VERSION_PATCH_LEVEL}")
if(NOT KERNEL_VERSION_BUILD_TYPE STREQUAL "")
    set(DLL_VERSION_STR "${DLL_VERSION_STR}-${KERNEL_VERSION_BUILD_TYPE}")
endif()

# Get Git revision through "git describe"
set(COMMIT_HASH "unknown-hash")
set(REVISION "unknown-revision")

if((EXISTS "${REACTOS_SOURCE_DIR}/.git") AND (NOT NO_REACTOS_BUILDNO))
    find_package(Git)
    if(GIT_FOUND)
        execute_process(
            COMMAND "${GIT_EXECUTABLE}" rev-parse HEAD
            WORKING_DIRECTORY ${REACTOS_SOURCE_DIR}
            OUTPUT_VARIABLE GIT_COMMIT_HASH
            RESULT_VARIABLE GIT_CALL_RESULT
            OUTPUT_STRIP_TRAILING_WHITESPACE
        )
        if(GIT_CALL_RESULT EQUAL 0)
            set(COMMIT_HASH "${GIT_COMMIT_HASH}")
        endif()

        execute_process(
            COMMAND "${GIT_EXECUTABLE}" rev-parse --abbrev-ref HEAD
            WORKING_DIRECTORY ${REACTOS_SOURCE_DIR}
            OUTPUT_VARIABLE GIT_BRANCH
            RESULT_VARIABLE GIT_CALL_RESULT
            OUTPUT_STRIP_TRAILING_WHITESPACE
        )
        if(GIT_CALL_RESULT EQUAL 0)
            set(BRANCH "${GIT_BRANCH}")
        endif()

        execute_process(
            COMMAND "${GIT_EXECUTABLE}" describe --abbrev=7 --long --always
            WORKING_DIRECTORY ${REACTOS_SOURCE_DIR}
            OUTPUT_VARIABLE GIT_DESCRIBE_REVISION
            RESULT_VARIABLE GIT_CALL_RESULT
            OUTPUT_STRIP_TRAILING_WHITESPACE
        )
        if(GIT_CALL_RESULT EQUAL 0)
            set(REVISION "${GIT_DESCRIBE_REVISION}")
        endif()
    endif()
endif()

# Get build computer name and builder username
if(NOT NO_REACTOS_BUILDNO)
    execute_process(
        COMMAND hostname
        OUTPUT_VARIABLE BUILD_COMPUTER_NAME
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    set(BUILD_COMPUTER_NAME "${BUILD_COMPUTER_NAME}")

    execute_process(
        COMMAND ${CMAKE_COMMAND} -E environment
        OUTPUT_VARIABLE ENV_VARS
    )
    string(REGEX MATCH "USERNAME=([^\n\r]*)" _ ${ENV_VARS})
    if(_ MATCHES "USERNAME=(.*)")
        set(BUILDER_USERNAME "${CMAKE_MATCH_1}")
    else()
        # Fallback for systems without USERNAME variable (e.g., Unix)
        execute_process(
            COMMAND whoami
            OUTPUT_VARIABLE BUILDER_USERNAME
            OUTPUT_STRIP_TRAILING_WHITESPACE
        )
    endif()
endif()

# Configure header files
configure_file(sdk/include/reactos/version.h.cmake ${REACTOS_BINARY_DIR}/sdk/include/reactos/version.h)
configure_file(sdk/include/reactos/buildno.h.cmake ${REACTOS_BINARY_DIR}/sdk/include/reactos/buildno.h)
