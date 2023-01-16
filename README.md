# Projet Bare Metal

## Introduction
### Abreviations

| Sigle | Définition                           |
|-------|--------------------------------------|
| CMSIS | Common MCU System Interface Standard |
| gcc   | Gnu C Compiler                       |
| gdb   | Gnu DeBugger                         |
| HAL   | Hardware Abstraction Layer           |
| MCU   | MicroController Unit                 |


## Commandes

Les commandes à disposition dans le Makefile sont :
- `make` ou `make all` compile le programme vers *./build/target/final.elf*.
- `make flash` compile et charge le programme sur la carte avec openocd.
- `make clean` ou `make clean-main` supprime les fichiers compiler liés au main.
- `make clean-all` supprime les fichiers compiler liés au main, au CMSIS et à la HAL.
- `make debug` charge le programme sur la carte et ouvre un serveur *gdb*. Cette commande est a utiliser avec `make gdb`.
- `make gdb` lance le gdb et le connecte au serveur produit par `make debug`. Cette commande doit être utilisée sur un second terminal.
- `make echoes` sert au debug du Makefile en printant certaines macros.


## Outils 

Les outils necessaires au fonctionnement de ce projet sont :
- **make**
- **arm-none-eabi-gcc**
- **gdb ou gdb-multiarch**
- **openocd**

### Make
Pour installer l'outil make il faut executer la commande :
- `sudo apt-get install make` sous *Ubuntu*
- `brew install make` sous *MacOS*

### arm-none-eabi-gcc
Pour installer la toolchain arm il faut executer la commande :
- `sudo apt-get install gcc-arm-none-eabi` sous *Ubuntu*
- `brew install arm-none-eabi-gcc` sous *MacOS*

### gdb ou gdb-multiarch
Pour installer le debugger il faut executer la commande :
- `sudo apt-get install gdb-multiarch` sous *Ubuntu*
- `brew install gdb` sous *MacOS*

### openocd


Pour installer l'outil openocd, sous Ubuntu il est recommandé de compiler openocd sur la machine. Il faut avoir au prealable installé les outils :
- autoconf 
- libtool 
- pkg-config 
- libusb-1.0-0
- libusb-1.0-0-dev

Il faut ensuite telecharger les codes sources de openocd, et les compiler en faisant :
1. `cd openocd`
2. `./bootstrap`
3. `./configure --enable-ftdi --enable-stlink`
4. `make`
5. `sudo make install`
Et normalement openocd est prêt à l'emploi.

Sous MacOS l'utilisation de brew fonctionne avec :
`brew install openocd`

## Documentations

Tutos utilisés :
- [Bare Metal - From zero to blink](https://linuxembedded.fr/2021/02/bare-metal-from-zero-to-blink)
- [STM32 without CubeIDE Part 1](https://kleinembedded.com/stm32-without-cubeide-part-1-the-bare-necessities)
- [STM32 without CubeIDE Part 2](https://kleinembedded.com/stm32-without-cubeide-part-2-cmsis-make-and-clock-configuration/)
- [OpenOCD from scratch](https://www.linuxembedded.fr/2018/08/openocd-from-scratch)
- [Quick Introduction to Debugging with GDB + OpenOCD](https://engr523.github.io/gdb_instructions.html)

Code source STMicroelectronics : 
- [STM32CubeF4](https://github.com/STMicroelectronics/STM32CubeF4)
