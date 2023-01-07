# Blink Project - Merlin

##############################################

PROJ_NAME=blink
CHIP_VENDOR = ST
CHIP_FAMILLY = STM32F4xx
CHIP = STM32F407xx

##############################################

# Tools
CC = arm-none-eabi-gcc
GDB = gdb
OCD = openocd

##############################################

# Directories
WORKSPACE = .
INCDIR = $(WORKSPACE)/inc
SRCDIR = $(WORKSPACE)/src
OBJDIR = $(WORKSPACE)/obj
CMSISDIR = $(WORKSPACE)/CMSIS
INC_CMSIS = $(CMSISDIR)/Include
INC_CMSIS_DEVICE = $(CMSISDIR)/Device/$(CHIP_VENDOR)/$(CHIP_FAMILLY)/Include
TARGETDIR = $(WORKSPACE)/target

# Files
TARGET = $(TARGETDIR)/$(PROJ_NAME).elf
SRCS = $(wildcard $(SRCDIR)/*.c)
OBJS = $(SRCS:.c=.o)
OBJS := $(subst $(SRCDIR)/,$(OBJDIR)/,$(OBJS))

##############################################

# HAL Directories
HALDIR = $(WORKSPACE)/HAL
HALINCDIR = $(HALDIR)/Inc
HALSRCDIR = $(HALDIR)/Src
HALOBJDIR = $(HALDIR)/Obj

# HAL Files
HALSRCS = $(wildcard $(HALSRCDIR)/*.c $(HALSRCDIR)/Legacy/*.c)
HALOBJS = $(HALSRCS:.c=.o)
HALOBJS := $(subst $(HALSRCDIR)/,$(HALOBJDIR)/,$(HALOBJS))
HALLIB = $(HALDIR)/libhal.a

##############################################

# Compiler Flags
MACH = cortex-m4
CFLAGS = -c -mcpu=$(MACH) -mthumb -std=gnu11

#Includes
INCFLAGS = -I$(INCDIR)
INCFLAGS += -I$(INC_CMSIS)
INCFLAGS += -I$(INC_CMSIS_DEVICE) -D $(CHIP)
INCFLAGS += -I$(HALINCDIR)
INCFLAGS += -I$(HALINCDIR)/Legacy

# Linker Flags
LDFLAGS = -T stm32_ls.ld -nostdlib #-Wl,-Map=final.map
#LDFLAGS += -L$(HALDIR) -lhal

# Debug Flags
DBGCFLAGS = -g -O0 -DDEBUG

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

.PHONY = all clean debug flash gdb echoes hal clean-hal

all : $(TARGET)

$(HALOBJDIR)/%.o : $(HALSRCDIR)/%.c
	mkdir -p $(@D)
	$(CC) $(CFLAGS) $(INCFLAGS) $(DBGCFLAGS) $^ -o $@ 

$(OBJDIR)/%.o : $(SRCDIR)/%.c
	mkdir -p $(@D)
	$(CC) $(CFLAGS) $(INCFLAGS) $(DBGCFLAGS) $^ -o $@

$(TARGET) : ${OBJS} 
	mkdir -p $(@D)
	$(CC) $(LDFLAGS) $(DBGCFLAGS) $^ -o $@
	@echo "-----------------------------"
	@echo "---   Target Build Done   ---"
	@echo "-----------------------------"

clean : 
	rm -rf $(OBJDIR) $(TARGETDIR)
	rm -rf $(HALOBJDIR) $(HALLIB)

debug : $(TARGET)
	$(OCD) -f $(OCD_DBG) -f $(OCD_CHIP) -c init $(DBG_CMDS)

flash : $(TARGET)
	$(OCD) -f $(OCD_DBG) -f $(OCD_CHIP) -c init $(FLASH_CMDS)

gdb:
	$(GDB) --eval-command="target remote localhost:3333" $(TARGET)

echoes :
	@echo "Hal lib files : $(HALLIB)"