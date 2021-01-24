# Creates a C/C++ header file that contains the current version of the project as
# hard-coded preprocessor defines.
function(make_version_header file_path project_name major minor patch tweak)
    string(TOUPPER ${project_name} project_name_caps)
    string(REPLACE "-" "_" project_name_caps ${project_name_caps})
    file(WRITE "${file_path}/${project_name}_version.h"
            "/**\n"
            " * @file\n"
            " * @brief Generated File - Contains version information.\n"
            " * @details Created using CMake configuration files.\n"
            " * This file contains simple preprocessor defines that can be read by C/C++ code.\n"
            " */\n"
            "\n"
            "/// The complete four part version number. It is a string literal of integers separated by dots.\n"
            "#define ${project_name_caps}_VERSION_STRING \"${major}.${minor}.${patch}.${tweak}\"\n"
            "/// An integer literal representing the Major part of the version number.\n"
            "#define ${project_name_caps}_VERSION_MAJOR ${major}\n"
            "/// An integer literal representing the Minor part of the version number.\n"
            "#define ${project_name_caps}_VERSION_MINOR ${minor}\n"
            "/// An integer literal representing the Patch count of the version number.\n"
            "#define ${project_name_caps}_VERSION_PATCH ${patch}\n"
            "/// An integer literal representing the Tweak count of the version number.\n"
            "#define ${project_name_caps}_VERSION_TWEAK ${tweak}\n"
            )
endfunction()
