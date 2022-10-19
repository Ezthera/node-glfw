project(NODE_GLFW CXX)

cmake_minimum_required(VERSION 3.15)
cmake_policy(SET CMP0091 NEW)
cmake_policy(SET CMP0042 NEW)

if (CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
    set(ELECTRON_BUILD 1)
endif()

set(CMAKE_CXX_STANDARD 11)

set(NODE_GLFW_VERSION_MAJOR "0")
set(NODE_GLFW_VERSION_MINOR "2")
set(NODE_GLFW_VERSION_PATCH "0")
set(NODE_GLFW_VERSION "${NODE_GLFW_VERSION_MAJOR}.${NODE_GLFW_VERSION_MINOR}")
set(NODE_GLFW_VERSION_FULL "${NODE_GLFW_VERSION}.${NODE_GLFW_VERSION_PATCH}")

find_package(OpenGL REQUIRED)

add_subdirectory(deps/glfw-3.0.4)

file (GLOB ADDON_HEADERS "src/*.h")
file(GLOB ADDON_SOURCES "src/*.cc" ${ADDON_HEADERS})
add_library(${PROJECT_NAME} SHARED ${ADDON_SOURCES} deps/glew-1.10.0/src/glew.c ${CMAKE_JS_SRC})

add_dependencies(${PROJECT_NAME} glfw)

set_target_properties(${PROJECT_NAME} PROPERTIES
    OUTPUT_NAME "glfw"
    PREFIX ""
    SUFFIX ".node"
)

target_include_directories(${PROJECT_NAME} PRIVATE ${CMAKE_JS_INC})
target_include_directories(${PROJECT_NAME} PRIVATE ${ADDON_HEADERS} deps/glew-1.10.0/include deps/glfw-3.0.4/include)

add_definitions(-DVERSION${NODE_GLFW_VERSION_FULL})

if (ELECTRON_BUILD)
    target_include_directories(${PROJECT_NAME} PRIVATE $ENV{LIBCXX_DIR}/include/c++/v1)
endif()

target_link_libraries(${PROJECT_NAME} PRIVATE ${CMAKE_JS_LIB})

if (MSVC)
    add_definitions(-DWIN32_LEAN_AND_MEAN)
    add_definitions(-DVC_EXTRALEAN)

    target_link_libraries(${PROJECT_NAME} PRIVATE opengl32 glu32 ${PROJECT_BINARY_DIR}/deps/glfw-3.0.4/src/${CMAKE_BUILD_TYPE}/glfw3dll.lib)

    if (ELECTRON_BUILD)
        target_link_libraries(${PROJECT_NAME} PRIVATE $ENV{LIBCXX_DIR}/lib/Release/c++.lib)
    endif()
elseif(UNIX)
    target_link_libraries(${PROJECT_NAME} PRIVATE glfw GLU)

    if (ELECTRON_BUILD)
        target_compile_options(${PROJECT_NAME} PRIVATE
            -stdlib=libc++
            -nostdinc++
            -nodefaultlibs)

        target_link_libraries(${PROJECT_NAME} PRIVATE c c++ c++abi gcc_s)
    endif()
endif()
