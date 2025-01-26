################################
# Sokol
################################

if(BUILD_SOKOL)
set(SOKOL_LIB_SRC ${CMAKE_SOURCE_DIR}/src/system/sokol/sokol.c)

add_library(sokol STATIC ${SOKOL_LIB_SRC})

if(APPLE)
    target_compile_definitions(sokol PRIVATE SOKOL_METAL)
elseif(WIN32)
    target_compile_definitions(sokol PRIVATE SOKOL_D3D11)
endif()

if(APPLE)

    target_link_libraries(sokol
        "-framework Cocoa"
        "-framework QuartzCore"
        "-framework Metal"
        "-framework MetalKit"
        "-framework AudioToolbox"
    )
elseif(WIN32)
    target_link_libraries(sokol D3D11)
endif()

target_include_directories(sokol PRIVATE ${THIRDPARTY_DIR}/sokol)
endif()

################################
# Sokol standalone cart player
################################

if(BUILD_PLAYER AND BUILD_SOKOL)

    add_executable(player-sokol WIN32 ${CMAKE_SOURCE_DIR}/src/system/sokol/player.c)

    target_include_directories(player-sokol PRIVATE
        ${CMAKE_SOURCE_DIR}/include
        ${THIRDPARTY_DIR}/sokol
        ${CMAKE_SOURCE_DIR}/src)

    target_link_libraries(player-sokol tic80core sokol)
endif()

################################
# TIC-80 app (Sokol)
################################

if(BUILD_SOKOL)

    set(TIC80_SRC ${CMAKE_SOURCE_DIR}/src/system/sokol/main.c)

    if(WIN32)

        configure_file("${PROJECT_SOURCE_DIR}/build/windows/tic80.rc.in" "${PROJECT_SOURCE_DIR}/build/windows/tic80.rc")
        set(TIC80_SRC ${TIC80_SRC} "${PROJECT_SOURCE_DIR}/build/windows/tic80.rc")

        add_executable(tic80 WIN32 ${TIC80_SRC})
    else()
        add_executable(tic80 ${TIC80_SRC})
    endif()

    target_include_directories(tic80 PRIVATE
        ${CMAKE_SOURCE_DIR}/include
        ${CMAKE_SOURCE_DIR}/src
        ${THIRDPARTY_DIR}/sokol)

    target_link_libraries(tic80 tic80studio sokol)

endif()