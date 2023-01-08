# Blink Project - Merlin

##############################################
################## PROJECT ###################
##############################################

PROJ_NAME=blink
CHIP_VENDOR = ST
CHIP_FAMILLY = STM32F4xx
CHIP = STM32F407xx
HOST_OS = $(shell uname)

##############################################
################### TOOLS ####################
##############################################

# Tools
ifeq ($(HOST_OS), Darwin) 
	CC = /usr/local/bin/arm-none-eabi-gcc
	GDB = /usr/local/bin/gdb
	OCD = /usr/local/bin/openocd
endif
ifeq ($(HOST_OS), Linux)
	CC = /usr/bin/arm-none-eabi-gcc
	GDB = /usr/bin/gdb-multiarch
	OCD = /usr/local/bin/openocd
endif

##############################################
################ DIRECTORIES #################
##############################################

# Directories
WORKSPACE = .
BUILD_DIR = $(WORKSPACE)/build
MAIN_DIR = $(WORKSPACE)/main
TOOLS_DIR = $(WORKSPACE)/tools
CMSIS_DIR = $(TOOLS_DIR)/CMSIS
HAL_DIR = $(TOOLS_DIR)/HAL
TARGET_DIR = $(BUILD_DIR)/target

##############################################
################### MAIN #####################
##############################################

# Main Directories
MAIN_INCDIR = $(MAIN_DIR)/inc
MAIN_SRCDIR = $(MAIN_DIR)/src
MAIN_OBJDIR = $(BUILD_DIR)/main

# Files
MAIN_SRCS = $(wildcard $(MAIN_SRCDIR)/*.c)
MAIN_OBJS = $(MAIN_SRCS:.c=.o)
MAIN_OBJS := $(subst $(MAIN_SRCDIR)/,$(MAIN_OBJDIR)/,$(MAIN_OBJS))
TARGET = $(TARGET_DIR)/final.elf

##############################################
################### CMSIS #####################
##############################################

# CMSIS Directories
CMSIS_INCDIR = $(CMSIS_DIR)/Include
CMSIS_INCDIR_DEVICE = $(CMSIS_DIR)/Device/$(CHIP_VENDOR)/$(CHIP_FAMILLY)/Include
CMSIS_SRCDIR_DEVICE = $(CMSIS_DIR)/Device/$(CHIP_VENDOR)/$(CHIP_FAMILLY)/Source
CMSIS_OBJDIR = $(BUILD_DIR)/cmsis

# CMSIS Files
CMSIS_SRCS = $(wildcard $(CMSIS_SRCDIR_DEVICE)/*.c)
CMSIS_OBJS = $(CMSIS_SRCS:.c=.o)
CMSIS_OBJS := $(subst $(CMSIS_SRCDIR_DEVICE)/,$(CMSIS_OBJDIR)/,$(CMSIS_OBJS))

##############################################
#################### HAL #####################
##############################################

# HAL Directories
HAL_INCDIR = $(HAL_DIR)/Inc
HAL_SRCDIR = $(HAL_DIR)/Src
HAL_OBJDIR = $(BUILD_DIR)/hal

# HAL Files
HAL_SRCS = $(wildcard $(HAL_SRCDIR)/*.c $(HAL_SRCDIR)/Legacy/*.c)
HAL_OBJS = $(HAL_SRCS:.c=.o)
HAL_OBJS := $(subst $(HAL_SRCDIR)/,$(HAL_OBJDIR)/,$(HAL_OBJS))

##############################################
################### FLAGS ####################
##############################################

# Compiler Flags
MACH = cortex-m4
CFLAGS = -c -mcpu=$(MACH) -mthumb -std=gnu11

#Includes
INCFLAGS = -I$(MAIN_INCDIR)
INCFLAGS += -I$(CMSIS_INCDIR)
INCFLAGS += -I$(CMSIS_INCDIR_DEVICE) -D $(CHIP)
INCFLAGS += -I$(HAL_INCDIR)
INCFLAGS += -I$(HAL_INCDIR)/Legacy

# Linker Flags
LDFLAGS = -T stm32_ls.ld #-Wl,-Map=final.map
#LDFLAGS += -nostartfiles 
LDFLAGS += -nostdlib
LDFLAGS += -lgcc -lc -lm

# Debug Flags
DBGCFLAGS = -g -O0 -DDEBUG

##############################################
################ OCD CONFIGS #################
##############################################

# OCD configuration
OCD_DBG = interface/stlink-v2-1.cfg
OCD_CHIP = target/stm32f4x.cfg

# Flash Commands
FLASH_CMDS += -c 'reset halt'
FLASH_CMDS += -c 'program $(TARGET)'
FLASH_CMDS += -c 'reset'
FLASH_CMDS += -c 'shutdown'

# Debug Commands
DBG_CMDS += -c 'reset halt'
DBG_CMDS += -c 'program $(TARGET)'
DBG_CMDS += -c 'reset halt'

##############################################
################### MAKE #####################
##############################################

.PHONY = all clean clean-all debug flash gdb echoes hal clean-hal

all : $(TARGET)

$(CMSIS_OBJDIR)/%.o : $(CMSIS_SRCDIR_DEVICE)/%.c
	mkdir -p $(@D)
	$(CC) $(CFLAGS) $(INCFLAGS) $(DBGCFLAGS) $^ -o $@ 

$(HAL_OBJDIR)/%.o : $(HAL_SRCDIR)/%.c
	mkdir -p $(@D)
	$(CC) $(CFLAGS) $(INCFLAGS) $(DBGCFLAGS) $^ -o $@ 

$(MAIN_OBJDIR)/%.o : $(MAIN_SRCDIR)/%.c
	mkdir -p $(@D)
	$(CC) $(CFLAGS) $(INCFLAGS) $(DBGCFLAGS) $^ -o $@

$(TARGET) : $(CMSIS_OBJS) $(HAL_OBJS) ${MAIN_OBJS} 
	mkdir -p $(@D)
	$(CC) $^ $(LDFLAGS) -o $@
	@echo "*****************************"
	@echo "***   Target Build Done   ***"
	@echo "*****************************"

clean :
	rm -rf $(TARGET) $(MAIN_OBJDIR)


clean-all : 
	rm -rf $(BUILD_DIR)

debug : $(TARGET)
	$(OCD) -f $(OCD_DBG) -f $(OCD_CHIP) -c init $(DBG_CMDS)

flash : $(TARGET)
	$(OCD) -f $(OCD_DBG) -f $(OCD_CHIP) -c init $(FLASH_CMDS)

gdb:
	$(GDB) --eval-command="target remote localhost:3333" $(TARGET)

echoes :
	@echo "Host OS : $(HOST_OS)"
	@echo "MAIN Directory : $(MAIN_DIR)"
	@echo "TOOLS Directory : $(TOOLS_DIR)"
	@echo "CMSIS Directory : $(CMSIS_DIR)"
	@echo "HAL Directory : $(HAL_DIR)"