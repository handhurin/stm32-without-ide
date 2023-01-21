/**
 * @file main.c
 * @author Merlin Kooshmanian
 * @brief Blink sans IDE en bare-metal
 * @version 0.1
 * @date 26/12/2022
 * 
 * @copyright Copyright (c) 2022
 * 
 */

/***************************** Include Files *********************************/
#include <stdint.h>
#include <stdio.h>

#include "main.h"
#include "stm32f407g-discovery_bsp.h"
#include "init.h"

/************************** Constant Definitions *****************************/

/**************************** Type Definitions *******************************/

/************************** Function Prototypes ******************************/

/************************** Variable Definitions *****************************/

/************************* Functions Definitions *****************************/

uint32_t main(void){
  //Initialisation des variables
  uint32_t fooVar = 0;

  //Initialisation
  init();
  
  /*Set LEDs default state*/
  HAL_GPIO_WritePin(LD4_GPIO_Port, LD4_Pin, GPIO_PIN_RESET);
  HAL_GPIO_WritePin(LD5_GPIO_Port, LD5_Pin, GPIO_PIN_RESET);
  HAL_GPIO_WritePin(LD3_GPIO_Port, LD3_Pin, GPIO_PIN_SET);
  HAL_GPIO_WritePin(LD6_GPIO_Port, LD6_Pin, GPIO_PIN_SET);

  while(1){
    /*Toggle LEDs*/
    HAL_GPIO_TogglePin(LD4_GPIO_Port, LD4_Pin);
    HAL_GPIO_TogglePin(LD5_GPIO_Port, LD5_Pin);
    HAL_GPIO_TogglePin(LD3_GPIO_Port, LD3_Pin);
    HAL_GPIO_TogglePin(LD6_GPIO_Port, LD6_Pin);

    printf("Compteur : %d\n", fooVar);
    fooVar++;

    HAL_Delay(500);
  }
}