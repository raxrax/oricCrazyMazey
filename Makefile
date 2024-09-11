#)              _
#)  ___ ___ _ _|_|___ ___
#) |  _| .'|_'_| |_ -|_ -|
#) |_| |__,|_,_|_|___|___|
#)         raxiss (c) 2020

PROJECT                 := test
PROJECT_DIR             := $(shell pwd)
PROJECT_LABEL           := test
PROJECT_VERSION         := 1.00

# # # Only for FlopyBuilder
# PROJECT_DSK           := $(PROJECT).dsk

# # # extra TAPs to include/exclude in/from DSK
PROJECT_DSK_INCLUDE     :=
PROJECT_DSK_EXCLUDE     :=

# # # Autorun main project file
PROJECT_AUTORUN         := 1

# # # Leave DOS
PROJECT_QUITDOS         := 0

# # # 6502, 65816
CPU                     := 6502

# # # Toolchain OSDK or CC65
TOOLCHAIN               := CC65

# # # -ma -m1 -mt -mp
MACH                    := -ma

# # #
-include                 ./Makefile.local
-include                 ~/.oric/Makefile.local

#
OSDK                    := $(OSDK_DIR)
OSDK_OPT                := 0
CC65                    := $(CC65_DIR)
CC65_ALIGNED            := 0

# # #
START_ADDRESS           := $(shell echo $$((0x600)))
CPROJECT 				:= $(PROJECT)

# # #
ATAPS                   := $(APROJECT)
BTAPS                   := $(BPROJECT)
CTAPS                   := $(CPROJECT)
OTAPS                   :=

TAPS                    := $(addsuffix .tap,$(ATAPS) $(BTAPS) $(CTAPS) $(OTAPS))

# # #
PROJECT_DSK_INCLUDE     +=
PROJECT_DSK_EXCLUDE     +=

# common_SRC            := compat.s via.s isr.s keyboard.s vsync.s vsync-auto.s psg.s reboot.s
common_SRC              := compat.s libsedoric.s ginp.s joys.s sfx.s psg.s dlzsa.s spritesa.s waitms.s

# # #
$(APROJECT)_SRC         := $(APROJECT).s
$(APROJECT)_AUTORUN     := 1
$(APROJECT)_ADDRESS     := $(START_ADDRESS)
$(APROJECT)_ACPP        := 1

# # #
$(BPROJECT)_SRC          := $(BPROJECT)
$(BPROJECT)_AUTORUN      := 1
# $(BPROJECT)_ADDRESS      :=
# $(BPROJECT)_ACPP         :=

# # #
$(CPROJECT)_SRC         := $(common_SRC) main.c
$(CPROJECT)_AUTORUN     := 1
$(CPROJECT)_ADDRESS     := $(START_ADDRESS)
$(CPROJECT)_ACPP        := 1

EMU                     := ./oricutron
EMUDIR                  := $(EMUL_DIR)
EMUARG                  := $(MACH)
EMUARG                  += --serial none
EMUARG                  += --turbotape on
EMUARG                  += --vsynchack off
EMUARG                  += -s $(PROJECT_DIR)/$(PROJECT).sym
EMUARG                  += -r :$(PROJECT_DIR)/$(PROJECT).brk
EMUARG                  += #-r $(START_ADDRESS)

#
COMMON                  := $(COMMON_DIR)
SRC                     := lib/ src/ res/
#
VPATH                   := $(VPATH) $(SRC) $(COMMON)

PREPARE                 := prepare
FINALIZE                := finalize

#
include                 $($(TOOLCHAIN))/atmos.make

#
AFLAGS                  += $(addprefix -I,$(VPATH))
AFLAGS                  += -DASSEMBLER

AFLAGS                  += -DUSE_ROMCALLS

# AFLAGS                  += -DUSE_VSYNC
# AFLAGS                  += -DUSE_VSYNC_50HZ
# AFLAGS                  += -DUSE_VSYNC_60HZ
# AFLAGS                  += -DUSE_VSYNC_SOFT
# AFLAGS                  += -DUSE_VSYNC_HARD
# AFLAGS                  += -DUSE_VSYNC_NEGEDGE
# AFLAGS                  += -DUSE_VSYNC_AUTO_TEXT

AFLAGS                  += -DUSE_JOYSTICK
AFLAGS                  += -DUSE_JOYSTICK_IJK
# AFLAGS                  += -DUSE_JOYSTICK_ALTAI

#
CFLAGS                  += $(addprefix -I,$(VPATH))

CFLAGS                  += -DUSE_ROMCALLS

# CFLAGS                  += -DUSE_VSYNC
# CFLAGS                  += -DUSE_VSYNC_50HZ
# CFLAGS                  += -DUSE_VSYNC_60HZ
# CFLAGS                  += -DUSE_VSYNC_SOFT
# CFLAGS                  += -DUSE_VSYNC_HARD
# CFLAGS                  += -DUSE_VSYNC_NEGEDGE
# CFLAGS                  += -DUSE_VSYNC_AUTO_TEXT

CFLAGS                  += -DUSE_JOYSTICK
CFLAGS                  += -DUSE_JOYSTICK_IJK
# CFLAGS                  += -DUSE_JOYSTICK_ALTAI

# $(APROJECT)_AFLAGS      +=
# $(APROJECT)_CFLAGS      +=
# $(APROJECT)_LFLAGS      += -D__GRAB__=1
#
$(APROJECT)_AFLAGS       := -DSTART_ADDRESS=$(START_ADDRESS)
$(APROJECT)_CFLAGS       := -DSTART_ADDRESS=$(START_ADDRESS)

# $(CPROJECT)_AFLAGS      +=
# $(CPROJECT)_CFLAGS      +=
# $(CPROJECT)_LFLAGS      += -D__GRAB__=1
#
$(CPROJECT)_AFLAGS       := -DSTART_ADDRESS=$(START_ADDRESS)
$(CPROJECT)_CFLAGS       := -DSTART_ADDRESS=$(START_ADDRESS)

# # # additional file to delete
TEMP_FILES              +=

AFLAGS                  += -DUSE_LZSA_SMALL -DUSE_LZSA_V2
CFLAGS                  += -DUSE_LZSA_SMALL -DUSE_LZSA_V2

prepare: nfo res

finalize: #hxc
	@echo   "[NFO]   ------------------------------"
# 	@([ -e $(APROJECT).brk ] || touch $(APROJECT).brk) || echo -n
# 	@printf "[MEM]   $(APROJECT)   : #%.4X .. #%.4X\\n" $$(($(START_ADDRESS))) $$(expr `cat $(APROJECT)  | wc -c` + $$(($(START_ADDRESS))))
# 	@echo   "[CRC]   $$(crc32 $(APROJECT))"
	@([ -e $(CPROJECT).brk ] || touch $(CPROJECT).brk) || echo -n
	@printf "[MEM]   $(CPROJECT)   : #%.4X .. #%.4X\\n" $$(($(START_ADDRESS))) $$(expr `cat $(CPROJECT)  | wc -c` + $$(($(START_ADDRESS))))
	@echo   "[CRC]   $$(crc32 $(CPROJECT))"

.PHONY: nfo res

nfo:
	@echo "Building with $(TOOLCHAIN):"

res:
	@$(CC65_DIR)/bin/bintoc.lua tiled/cm.mem ./src/tileset.c TILESET
	
	# @$(OSDK)/bin/pictconv -f0 -o2 tiled/bg.png tiled/bg.hrs
	# @$(OSDK)/bin/lzsa-1.3.4 -r -f2 tiled/bg.hrs tiled/bg.lzsa
	# @$(OSDK)/bin/bin2c tiled/bg.lzsa src/bgimg.c BGIMG
	
	@true
