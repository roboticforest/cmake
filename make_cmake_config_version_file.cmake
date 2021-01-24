function(make_cmake_config_version_file)
    message(VERBOSE "ENTERING: make_cmake_config_version_file()...")
    set(options "")
    set(args "")
    set(list_args "")
    cmake_parse_arguments(
            PARSE_ARGV 0    # Parsing mode and variable skip.
            "CV"            # Variable name prefix.
            "${options}"    # Known function options.
            "${args}"       # One value arguments.
            "${list_args}"  # Multivalued arguments.
    )
    foreach(arg IN LISTS CV_UNPARSED_ARGUMENTS)
        message(WARNING "Unknown argument: ${arg}")
    endforeach()
endfunction()


#set(PACKAGE_VERSION "0.4.0.0")
#
#if(PACKAGE_VERSION VERSION_LESS PACKAGE_FIND_VERSION)
#    set(PACKAGE_VERSION_COMPATIBLE FALSE)
#else()
#
#    if("0.4.0.0" MATCHES "^([0-9]+)\\.")
#        set(CVF_VERSION_MAJOR "${CMAKE_MATCH_1}")
#    else()
#        set(CVF_VERSION_MAJOR "0.4.0.0")
#    endif()
#
#    if(PACKAGE_FIND_VERSION_MAJOR STREQUAL CVF_VERSION_MAJOR)
#        set(PACKAGE_VERSION_COMPATIBLE TRUE)
#    else()
#        set(PACKAGE_VERSION_COMPATIBLE FALSE)
#    endif()
#
#    if(PACKAGE_FIND_VERSION STREQUAL PACKAGE_VERSION)
#        set(PACKAGE_VERSION_EXACT TRUE)
#    endif()
#endif()