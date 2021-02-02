cmake_minimum_required(VERSION 3.19.3)

function(make_cmake_config_file)
    message(VERBOSE "ENTERING: make_cmake_config_file().")
    set(options "")         # UNUSED
    set(args NAME PATH VAR_PREFIX)
    set(list_args DEFINES SETTINGS)
    cmake_parse_arguments(
            PARSE_ARGV 0    # Parsing mode and variable skip.
            "CONF"          # Variable name prefix.
            "${options}"    # Known function options.
            "${args}"       # One value arguments.
            "${list_args}"  # Multivalued arguments.
    )

    if (NOT CONF_NAME)
        message(FATAL_ERROR "A \"NAME\" parameter must be specified. Typically this is the name of the project and it will be used as the prefix for the config file's name as \"<name>-config.cmake\".")
    else ()
        message(VERBOSE "Using name \"${CONF_NAME}\" for config file prefix.")
    endif ()

    # Allow for relative paths and/or account for missing PATH argument.
    if (CONF_PATH)
        message(VERBOSE "File creation path set to: \"${CONF_PATH}\"")
        file(REAL_PATH "${CONF_PATH}" CONF_INSTALL_PATH)
        message(VERBOSE "File creation path resolved to: \"${CONF_INSTALL_PATH}\"")
        set(CONF_INSTALL_PATH "${CONF_INSTALL_PATH}")
    else ()
        message(VERBOSE "No destination file creation path given. The default path is the project binary directory.")
        message(VERBOSE "Using \"${PROJECT_BINARY_DIR}\".")
        set(CONF_INSTALL_PATH "${PROJECT_BINARY_DIR}")
    endif ()

    foreach (arg IN LISTS CONF_UNPARSED_ARGUMENTS)
        message(WARNING "Unknown argument: ${arg}")
    endforeach ()

    string(TOLOWER "${CONF_NAME}" CONF_FILENAME)
    message(STATUS "Generating \"${CONF_FILENAME}-config.cmake\".")
    set(outfile "${CONF_INSTALL_PATH}/${CONF_FILENAME}-config.cmake")
    file(WRITE "${outfile}" "message(VERBOSE \"ENTERING: ${CONF_FILENAME}-config.cmake file.\")\n")

    foreach (define IN LISTS CONF_DEFINES)
        file(APPEND "${outfile}" "add_compile_definitions(${define})\n")
    endforeach ()

    foreach (setting IN LISTS CONF_SETTINGS)
        string(REGEX MATCH "^[^=]+" var_name ${setting})                                # Get the variable name.
        string(REPLACE "${var_name}=" "" var_value ${setting})                          # Get the value.
        file(APPEND "${outfile}" "set(${CONF_VAR_PREFIX}_${var_name} ${var_value})\n")  # Create the set variable command.
    endforeach ()

    file(APPEND "${outfile}" "message(VERBOSE \"EXITING: ${CONF_FILENAME}-config.cmake file.\")\n")

    message(VERBOSE "EXITING: make_cmake_config_file().")
endfunction()