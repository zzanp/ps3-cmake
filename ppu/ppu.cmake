if(NOT DEFINED ENV{PS3DEV})
    message(FATAL_ERROR "PS3DEV environment variable is undefined.")
endif()

set(PS3DEV $ENV{PS3DEV})
set(PPUROOT ${PS3DEV}/ppu)
set(PPUBIN ${PPUROOT}/bin)
set(PS3BIN ${PS3DEV}/bin)

set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR cell)

set(CMAKE_C_COMPILER ${PPUBIN}/ppu-gcc)
set(CMAKE_CXX_COMPILER ${PPUBIN}/ppu-g++)
set(CMAKE_STRIP ${PPUBIN}/ppu-strip)

set(CMAKE_FIND_ROOT_PATH ${PPUROOT})
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

set(PPU_FLAGS "-mcpu=cell -mhard-float -fmodulo-sched -ffunction-sections -fdata-sections")

set(OLD_CMAKE_C_FLAGS "${CMAKE_C_FLAGS}")
set(OLD_CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
set(OLD_CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS}")

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${PPU_FLAGS}" CACHE STRING "" FORCE)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${PPU_FLAGS} -Wall" CACHE STRING "" FORCE)
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${PPU_FLAGS} -Wl,--gc-sections" CACHE STRING "" FORCE)
set(CMAKE_LINK_DEPENDS_USE_LINKER FALSE)

include_directories(
    ${PPUROOT}/include 
    ${PPUROOT}/lib64/gcc/powerpc64-ps3-elf/7.2.0/include
    ${PPUROOT}/include/simdmath
)

link_directories(
    ${SPUROOT}/lib
)

function(target_add_ppu_executable TARGET_NAME)
    set(STRIPPED_ELF "${CMAKE_CURRENT_BINARY_DIR}/${TARGET_NAME}_stripped.elf")
    set(OUT_SELF "${CMAKE_CURRENT_BINARY_DIR}/${TARGET_NAME}.self")
    set(OUT_FSELF "${CMAKE_CURRENT_BINARY_DIR}/${TARGET_NAME}.fake.self")

    add_custom_command(TARGET ${TARGET_NAME} POST_BUILD
        COMMAND ${CMAKE_STRIP} $<TARGET_FILE:${TARGET_NAME}> -o ${STRIPPED_ELF}
        COMMAND ${PS3BIN}/sprxlinker ${STRIPPED_ELF}
        COMMAND ${PS3BIN}/make_self ${STRIPPED_ELF} ${OUT_SELF}
        COMMAND ${PS3BIN}/fself ${STRIPPED_ELF} ${OUT_FSELF}
        
        COMMENT "Generating ${TARGET_NAME}.self and ${TARGET_NAME}.fake.self"
    )
endfunction()

set(CMAKE_C_FLAGS "${OLD_CMAKE_C_FLAGS}")
set(CMAKE_CXX_FLAGS "${OLD_CMAKE_CXX_FLAGS}")
set(CMAKE_EXE_LINKER_FLAGS "${OLD_CMAKE_EXE_LINKER_FLAGS}")