# CMake Helper Scripts

I'm making this repo public.

If anyone finds these CMake scripts useful please let me know.

These scripts were originally written for a logging library I created for my game engine. As I learned more about CMake these scripts were rewritten and repurposed for the game engine library itself. I then extracted them as their own project and learned how to use git submodules.

# What Do The Scripts Do?

The two files `make_cmake_config_file.cmake` and `make_cmake_config_version_file.cmake` create (respectively) `<name>-config.cmake` and `<name>-config-version.cmake` files for CMake based library projects.

The file `make_cpp_version_header.cmake` outputs a simple `<name>_version.h` file with a few C++ preprocessor defines so that projects can be aware of their own version.

# Example Usage

```cmake
# Generate *-config.cmake file for library clients.
make_cmake_config_file(
        NAME ${PROJECT_NAME}
        VAR_PREFIX ${PROJECT_NAME}
        LIB_NAME ${LIBRARY_NAME}
        DEFINES SOME_DEF ANOTHER_DEF
        SETTINGS
            INCLUDE_DIRS="path/one;and/path/two;a/third/path"
            LIST_VAR="${SOME_LIST_VAR}"
)

# Generate *-config-version.cmake file for library clients.
make_cmake_config_version_file(
        NAME ${PROJECT_NAME}
        VERSION ${PROJECT_VERSION}
)

# Provide library version information to C++.
make_cpp_version_header(
        NAME ${PROJECT_NAME}
        PATH "inc"
        VERSION ${PROJECT_VERSION}
)
```
