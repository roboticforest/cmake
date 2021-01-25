# The following notes were taken from the CMake 3.16 documentation and are useful to have on hand here.

# INPUT variables supplied to the version file when find_package() loads it.
# PACKAGE_FIND_NAME           -   The <PackageName>
# PACKAGE_FIND_VERSION        -   Full requested version string
# PACKAGE_FIND_VERSION_MAJOR  -   Major version if requested, else 0
# PACKAGE_FIND_VERSION_MINOR  -   Minor version if requested, else 0
# PACKAGE_FIND_VERSION_PATCH  -   Patch version if requested, else 0
# PACKAGE_FIND_VERSION_TWEAK  -   Tweak version if requested, else 0
# PACKAGE_FIND_VERSION_COUNT  -   Number of version components, 0 to 4

# OUTPUT variables given back to CMake's find_package() function.
# PACKAGE_VERSION             -   Full provided version string
# PACKAGE_VERSION_EXACT       -   True if version is exact match
# PACKAGE_VERSION_COMPATIBLE  -   True if version is compatible
# PACKAGE_VERSION_UNSUITABLE  -   True if unsuitable as any version

# OUTPUT variables given back to the project that called find_package().
# The variables report the version of the package that was actually found. The <PackageName> part of their name
# matches the argument given to the find_package() command.
# <PackageName>_VERSION       -   Full provided version string
# <PackageName>_VERSION_MAJOR -   Major version if provided, else 0
# <PackageName>_VERSION_MINOR -   Minor version if provided, else 0
# <PackageName>_VERSION_PATCH -   Patch version if provided, else 0
# <PackageName>_VERSION_TWEAK -   Tweak version if provided, else 0
# <PackageName>_VERSION_COUNT -   Number of version components, 0 to 4

function(make_cmake_config_version_file)
    message(VERBOSE "ENTERING: make_cmake_config_version_file().")
    set(options "")         # UNUSED
    set(args NAME VERSION PATH)
    set(list_args "")       # UNUSED
    cmake_parse_arguments(
            PARSE_ARGV 0    # Parsing mode and variable skip.
            "CV"            # Variable name prefix.
            "${options}"    # Known function options.
            "${args}"       # One value arguments.
            "${list_args}"  # Multivalued arguments.
    )

    if (NOT CV_NAME)
        message(FATAL_ERROR "A \"NAME\" parameter must be specified. Typically this is the name of the project and it will be used as the prefix in the config version file's name as \"<name>-config-version.cmake\".")
    else ()
        message(VERBOSE "Using name \"${CV_NAME}\" for config version file prefix.")
    endif ()

    if (NOT CV_VERSION)
        message(FATAL_ERROR "A version number must be supplied which can be written in to the version file.")
    else ()
        message(VERBOSE "\"${CV_NAME}\" version set to \"${CV_VERSION}\"")
    endif ()

    # Allow for relative paths and/or account for missing PATH argument.
    if (CV_PATH)
        message(VERBOSE "File creation path set to: \"${CV_PATH}\"")
        set(CV_INSTALL_PATH "${CV_PATH}/")
    else ()
        message(VERBOSE "No destination file creation path given. The default path is the project binary directory.")
        message(VERBOSE "Using \"${PROJECT_BINARY_DIR}\".")
        set(CV_INSTALL_PATH "${PROJECT_BINARY_DIR}/")
    endif ()

    foreach (arg IN LISTS CV_UNPARSED_ARGUMENTS)
        message(WARNING "Unknown argument: ${arg}")
    endforeach ()

    message(STATUS "Generating \"${CV_NAME}-config-version.cmake\" for version \"${CV_VERSION}\" of \"${CV_NAME}\".")
    file(WRITE "${CV_INSTALL_PATH}${CV_NAME}-config-version.cmake"
            "message(VERBOSE \"ENTERING: ${CV_NAME}-config-version.cmake file.\")\n"
            "\n"
            "set(PACKAGE_VERSION \"${CV_VERSION}\")\n"
            "\n"
            "\# Backwards compatibility with previous minor iterations is assumed, but not for newer\n"
            "\# iterations. Nor is any compatibility assumed for any other major versions.\n"
            "\# Compatibility with previous patches and insignificant tweaks is also assumed.\n"
            "if(PACKAGE_VERSION VERSION_LESS PACKAGE_FIND_VERSION)\n"
            "    set(PACKAGE_VERSION_COMPATIBLE FALSE)\n"
            "else()\n"
            "    if(\"${CV_VERSION}\" MATCHES \"^([0-9]+)\\\\.\")\n"
            "        set(CV_VERSION_MAJOR_COMPONENT \"\${CMAKE_MATCH_1}\")\n"
            "    else()\n"
            "        set(CV_VERSION_MAJOR_COMPONENT \"${CV_VERSION}\")\n"
            "    endif()\n"
            "\n"
            "    if(PACKAGE_FIND_VERSION_MAJOR STREQUAL CV_VERSION_MAJOR_COMPONENT)\n"
            "        set(PACKAGE_VERSION_COMPATIBLE TRUE)\n"
            "    else()\n"
            "        set(PACKAGE_VERSION_COMPATIBLE FALSE)\n"
            "    endif()\n"
            "\n"
            "    if(PACKAGE_FIND_VERSION STREQUAL PACKAGE_VERSION)\n"
            "        set(PACKAGE_VERSION_EXACT TRUE)\n"
            "    endif()\n"
            "endif()\n"
            "\n"
            "if(PACKAGE_VERSION_COMPATIBLE)\n"
            "    message(VERBOSE \"Installed package (\${PACKAGE_VERSION}) is compatible with requested version (\${PACKAGE_FIND_VERSION}).\")\n"
            "    if(PACKAGE_VERSION_EXACT)\n"
            "        message(VERBOSE \"Package versions match exactly.\")\n"
            "    endif()\n"
            "endif()\n"
            "message(VERBOSE \"EXITING: ${CV_NAME}-config-version.cmake file.\")\n"
            )

    message(VERBOSE "EXITING: make_cmake_config_version_file().")
endfunction()
