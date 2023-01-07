# Blink Project - Merlin

##############################################
################## PROJECT ###################
##############################################

PROJ_NAME=blink
CHIP_VENDOR = ST
CHIP_FAMILLY = STM32F4xx
CHIP = STM32F407xx

##############################################
################### TOOLS ####################
##############################################

# Tools
CC = arm-none-eabi-gcc
GDB = gdb
OCD = openocd

##############################################
################ DIRECTORIES #################
##############################################

# Directories
WORKSPACE = .
BUILDDIR = $(WORKSPACE)/build
MAIN_DIR = $(WORKSPACE)/main
CMSIS_DIR = $(WORKSPACE)/CMSIS
HAL_DIR = $(WORKSPACE)/HAL
TARGETDIR = $(BUILDDIR)/target

##############################################
################### MAIN #####################
##############################################

# Main Directories
MAIN_INCDIR = $(MAIN_DIR)/inc
MAIN_SRCDIR = $(MAIN_DIR)/src
MAIN_OBJDIR = $(BUILDDIR)/main

# Files
SRCS = $(wildcard $(MAIN_SRCDIR)/*.c)
OBJS = $(SRCS:.c=.o)
OBJS := $(subst $(MAIN_SRCDIR)/,$(MAIN_OBJDIR)/,$(OBJS))
TARGET = $(TARGETDIR)/$(PROJ_NAME).elf

##############################################
################### CMSIS #####################
##############################################

# Main Directories

INC_CMSIS = $(CMSIS_DIR)/Include
INC_CMSIS_DEVICE = $(CMSIS_DIR)/Device/$(CHIP_VENDOR)/$(CHIP_FAMILLY)/Include

##############################################
#################### HAL #####################
##############################################

# HAL Directories
HAL_INCDIR = $(HAL_DIR)/Inc
HAL_SRCDIR = $(HAL_DIR)/Src
HAL_OBJDIR = $(BUILDDIR)/hal

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
INCFLAGS += -I$(INC_CMSIS)
INCFLAGS += -I$(INC_CMSIS_DEVICE) -D $(CHIP)
INCFLAGS += -I$(HAL_INCDIR)
INCFLAGS += -I$(HAL_INCDIR)/Legacy

# Linker Flags
LDFLAGS = -T stm32_ls.ld -nostdlib #-Wl,-Map=final.map

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

.PHONY = all clean debug flash gdb echoes hal clean-hal

all : $(TARGET)

$(HAL_OBJDIR)/%.o : $(HAL_SRCDIR)/%.c
	mkdir -p $(@D)
	$(CC) $(CFLAGS) $(INCFLAGS) $(DBGCFLAGS) $^ -o $@ 

$(MAIN_OBJDIR)/%.o : $(MAIN_SRCDIR)/%.c
	mkdir -p $(@D)
	$(CC) $(CFLAGS) $(INCFLAGS) $(DBGCFLAGS) $^ -o $@

$(TARGET) : ${OBJS} 
	mkdir -p $(@D)
	$(CC) $(LDFLAGS) $(DBGCFLAGS) $^ -o $@
	@echo "*****************************"
	@echo "***   Target Build Done   ***"
	@echo "*****************************"

clean : 
	rm -rf $(BUILDDIR)

debug : $(TARGET)
	$(OCD) -f $(OCD_DBG) -f $(OCD_CHIP) -c init $(DBG_CMDS)

flash : $(TARGET)
	$(OCD) -f $(OCD_DBG) -f $(OCD_CHIP) -c init $(FLASH_CMDS)

gdb:
	$(GDB) --eval-command="target remote localhost:3333" $(TARGET)

echoes :
	@echo "Test"