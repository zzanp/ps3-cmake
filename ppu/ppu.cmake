if(DEFINED ENV{PS3DEV})
    set(PS3DEV $ENV{PS3DEV})
else()
    message(FATAL_ERROR "PS3DEV path is undefined.")
endif ()

set(PPUROOT ${PS3DEV}/ppu)
set(PPUBIN ${PPUROOT}/bin)

set(CMAKE_PREFIX_PATH ${PPUROOT} ${PS3DEV}/portlibs/ppu ${PPUROOT}/powerpc64-ps3-elf)
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_C_COMPILER ${PPUBIN}/ppu-gcc)
set(CMAKE_CXX_COMPILER ${PPUBIN}/ppu-g++)
set(CMAKE_FIND_ROOT_PATH ${PPUROOT})
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
set(STRIP ${PPUBIN}/ppu-strip)

include_directories(${include_directories} ${PPUROOT}/include ${PS3DEV}/portlibs/ppu/include
	${PPUROOT}/powerpc64-ps3-elf/include)

add_definitions("-D_PS3")

set(PPU_LIBRARIES
	"-lc -lg -laudio -lcamera -lfont -lfontFT -lgcm_sys \
	-lgem -lhttp -lhttputil -lio -ljpgdec -llv2 \
	-llv2dbg -lnet -lnetctl -lpngdec -lresc -lrsx \
	-lrt -lsimdmath -lspumars -lspumarsjq -lspumarstask \
	-lspurs -lssl -lsysfs -lsysmodule -lsysutil -lusb -lvdec \
	-L${PPUROOT}/lib -L${PPUROOT}/powerpc64-ps3-elf/lib -L${PS3DEV}/portlibs/ppu/lib"
)

