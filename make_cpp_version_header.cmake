cmake_minimum_required(VERSION 3.19.3)

function(make_cpp_version_header)
    message(VERBOSE "ENTERING: make_cpp_version_header().")
    set(options "")         # UNUSED
    set(args NAME VERSION PATH)
    set(list_args "")       # UNUSED
    cmake_parse_arguments(
            PARSE_ARGV 0    # Parsing mode and variable skip.
            "HEADER"        # Variable name prefix.
            "${options}"    # Known function options.
            "${args}"       # One value arguments.
            "${list_args}"  # Multivalued arguments.
    )

    if (NOT HEADER_NAME)
        message(FATAL_ERROR "A \"NAME\" parameter must be specified. Typically this is the name of the project and it will be used as the prefix for the version header file as \"<name>_version.h\".")
    else ()
        message(VERBOSE "Using name \"${HEADER_NAME}\" as the version header file prefix.")
    endif ()

    if (NOT HEADER_VERSION)
        message(FATAL_ERROR "A version number must be supplied which can be written in to the version header file as a set of C preprocessor defines.")
    else ()
        message(VERBOSE "\"${HEADER_NAME}\" version set to \"${HEADER_VERSION}\"")
    endif ()

    # Allow for relative paths and/or account for missing PATH argument.
    if (HEADER_PATH)
        message(VERBOSE "File creation path set to: \"${HEADER_PATH}\"")
        file(REAL_PATH "${HEADER_PATH}" HEADER_INSTALL_PATH)
        message(VERBOSE "File creation path resolved to: \"${HEADER_INSTALL_PATH}\"")
        set(HEADER_INSTALL_PATH "${HEADER_INSTALL_PATH}")
    else ()
        message(VERBOSE "No destination file creation path given. The default path is the project binary directory.")
        message(VERBOSE "Using \"${PROJECT_BINARY_DIR}\".")
        set(HEADER_INSTALL_PATH "${PROJECT_BINARY_DIR}")
    endif ()

    foreach (arg IN LISTS HEADER_UNPARSED_ARGUMENTS)
        message(WARNING "Unknown argument: ${arg}")
    endforeach ()

    # Enforce the typical style of C/C++ preprocessor define constants.
    string(TOUPPER ${HEADER_NAME} ALL_CAPS_HEADER_NAME)
    string(REPLACE "-" "_" ALL_CAPS_HEADER_NAME ${ALL_CAPS_HEADER_NAME})

    # Generate the file.
    message(STATUS "Generating \"${HEADER_NAME}_version.h\" for version \"${HEADER_VERSION}\" of \"${HEADER_NAME}\".")
    set(outfile "${HEADER_INSTALL_PATH}/${HEADER_NAME}_version.h")
    file(WRITE "${outfile}"
            "/**\n"
            " * @file\n"
            " * @brief CMake Generated File - Contains version information.\n"
            " * @details Created using CMake project configuration files.\n"
            " * This file contains project version information as a set of simple preprocessor definitions.\n"
            " */\n"
            "\n"
            )

    file(APPEND "${outfile}"
            "/// The complete four part version number as a string literal.\n"
            "#define ${ALL_CAPS_HEADER_NAME}_version_listING \"${HEADER_VERSION}\"\n"
            )

    # Convert the version string into a list of version string components.
    set(version_list ${HEADER_VERSION})
    string(REPLACE "." ";" version_list ${version_list})

    # Loop though the list of version components, creating defines as we process them.
    set(indices "1;2;3;4")
    foreach (version_component i IN ZIP_LISTS version_list indices)

        if (NOT version_component)
            set(version_component 0)
        endif ()

        if (${i} EQUAL 1)
            file(APPEND "${outfile}"
                    "/// An integer literal representing the Major part of the version number.\n"
                    "#define ${ALL_CAPS_HEADER_NAME}_VERSION_MAJOR ${version_component}\n"
                    )
        elseif (${i} EQUAL 2)
            file(APPEND "${outfile}"
                    "/// An integer literal representing the Minor part of the version number.\n"
                    "#define ${ALL_CAPS_HEADER_NAME}_VERSION_MINOR ${version_component}\n"
                    )
        elseif (${i} EQUAL 3)
            file(APPEND "${outfile}"
                    "/// An integer literal representing the Patch count of the version number.\n"
                    "#define ${ALL_CAPS_HEADER_NAME}_VERSION_PATCH ${version_component}\n"
                    )
        elseif (${i} EQUAL 4)
            file(APPEND "${outfile}"
                    "/// An integer literal representing the Tweak count of the version number.\n"
                    "#define ${ALL_CAPS_HEADER_NAME}_VERSION_TWEAK ${version_component}\n"
                    )
        endif ()
    endforeach ()

    message(VERBOSE "EXITING: make_cpp_version_header().")
endfunction()