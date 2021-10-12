if(DEFINED ENV{PS3DEV})
    set(PS3DEV $ENV{PS3DEV})
else()
    message(FATAL_ERROR "PS3DEV path is undefined.")
endif ()

set(SPUROOT ${PS3DEV}/spu)
set(SPUBIN ${SPUROOT}/bin)

set(CMAKE_PREFIX_PATH ${SPUROOT} ${SPUROOT}/spu)
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_C_COMPILER ${SPUBIN}/spu-gcc)
set(CMAKE_CXX_COMPILER ${SPUBIN}/spu-g++)
set(CMAKE_FIND_ROOT_PATH ${SPUROOT})
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
set(STRIP ${SPUBIN}/spu-strip)

include_directories(${include_directories} ${SPUROOT}/include ${SPUROOT}/include)

add_definitions("-D_PS3")

set(SPU_LIBRARIES
	"-lc -lg -lgloss -lsimdmath -lspuatomic
	-lspudma -lspumars -lspumarstask -lsputhread \
	-L${SPUROOT}/lib -L${SPUROOT}/spu/lib"
)

