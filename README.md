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

### Contexte
Ce projet consiste en un développement de logiciel pour un microcontrôleur STM32 en utilisant un environnement de développement bare metal. Il n'utilise pas de système d'exploitation pour faire tourner le programme, mais accède directement au matériel. Cela nécessite une configuration manuelle des différents périphériques du microcontrôleur et une gestion directe de l'accès à la mémoire et aux entrées/sorties.

Pour mettre en œuvre ce projet, les outils suivants ont été utilisés : Make pour automatiser le processus de construction, un GCC pour compiler le code source en code binaire exécutable, GDB pour déboguer le code et OpenOCD pour charger le programme et faire l'interface entre la carte et GDB. Un makefile est utilisé pour définir les étapes de la construction, les dépendances entre les fichiers et les options de compilation. Le compilateur **arm-none-eabi-gcc** est utilisé pour compiler les fichiers source et créer des fichiers binaires exécutables pour le microcontrôleur. Le debugger **gdb** (**gdb-multiarch**) est utilisé pour déboguer le code en cours d'exécution sur le matériel, permettant de suivre l'exécution du code, de mettre des points d'arrêt et d'inspecter les variables. Enfin, OpenOCD est utilisé pour charger le programme sur la carte et pour établir une interface entre la carte et GDB.

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
Make est un outil de construction automatisé pour compiler les logiciels, il lit un fichier de configuration "makefile" pour construire les parties du logiciel, il permet de gagner du temps en ne recompilant que les parties modifiées et de gérer les dépendances entre différents fichiers pour créer des exécutables ou des bibliothèques.

Pour installer l'outil make il faut executer la commande :
- `sudo apt-get install make` sous *Ubuntu*
- `brew install make` sous *MacOS*

### arm-none-eabi-gcc
GCC est un outil important pour les étudiants en développement de systèmes embarqués. Il est un compilateur libre qui convertit les codes écrits dans divers langages en fichiers exécutables pour les processeurs embarqués. Il est utilisé pour construire des applications et des bibliothèques pour les systèmes embarqués, et peut générer des codes pour différentes architectures. Il est un outil polyvalent pour le développement de systèmes embarqués.

**Attention** dans ce projet nous avons utilisé la dernière toolchain ARM pour compiler le projet : la 10.3-xx (sur MacOS nous avons téléchargé la 10.3-2021.07 et sur Ubuntu nous avons téléchargé la 10.3-2021.07).

Sous Ubuntu, pour telecharger la dernière toolchain il faut faire :
- `sudo apt-get remove binutils-arm-none-eabi gcc-arm-none-eabi`
- `sudo add-apt-repository ppa:team-gcc-arm-embedded/ppa`
- `sudo apt-get install gcc-arm-none-eabi`

On peut eventuellement installer le GDB qui va avec même si on ne l'utilisera pas (on utilise gdb multi-arch à la place).
- `sudo apt-get install gdb-arm-none-eabi`

Et normalement les binaires se trouve à l'adresse */usr/bin/arm-none-eabi-gcc*.

Sous MacOS l'utilisation de brew fonctionne avec :
- `brew install arm-none-eabi-gcc` sous *MacOS* (version 10.3-2021.07)

### gdb ou gdb-multiarch
GDB est un débogueur logiciel utilisé pour trouver et corriger les erreurs dans les programmes. Il permet aux développeurs de suivre l'exécution d'un programme pas à pas, de mettre des points d'arrêt pour interrompre l'exécution à des moments précis, de visualiser les variables et les données de la mémoire, et de déboguer des programmes distribués. Il est souvent utilisé en combinaison avec des compilateurs tels que GCC pour permettre un développement efficace des programmes.

Pour installer le debugger il faut executer la commande :
- `sudo apt-get install gdb-multiarch` sous *Ubuntu*
- `brew install gdb` sous *MacOS*

### openocd
OpenOCD est un logiciel open source pour déboguer et programmer des systèmes embarqués. Il prend en charge un grand nombre de processeurs et de plateformes de développement, et permet de déboguer des systèmes en utilisant des protocoles comme le JTAG.  Il permet également la programmation de flash et la vérification de la mémoire.

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
