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

//Declaration de la carte ici pour <stm32f4xx.h>
#ifndef STM32F407xx
#define STM32F407xx /*!< STM32F407VG, STM32F407VE, STM32F407ZG, STM32F407ZE, STM32F407IG and STM32F407IE Devices */
#endif

#include <stdint.h>
#include <stm32f4xx.h>

#include "stm32f4xx_hal.h"
#include "sysclock.h"

/************************** Constant Definitions *****************************/
#define LD4_Pin                     GPIO_PIN_12
#define LD4_GPIO_Port               GPIOD
#define LD3_Pin                     GPIO_PIN_13
#define LD3_GPIO_Port               GPIOD
#define LD5_Pin                     GPIO_PIN_14
#define LD5_GPIO_Port               GPIOD
#define LD6_Pin                     GPIO_PIN_15
#define LD6_GPIO_Port               GPIOD

/**************************** Type Definitions *******************************/

/************************** Function Prototypes ******************************/

static void GPIO_Init(void);
void Error_Handler(void);
void SystemClock_Config(void);

/************************** Variable Definitions *****************************/

/************************* Functions Definitions *****************************/

int main(void){

  //Initialisation des outils
  clock_init();
  GPIO_Init();  
  
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

    delay_ms(500);                                  /* 500ms delay for 1Hz blinking */
  }
}

/**
  * @brief GPIO Initialization Function
  * @param None
  * @retval None
  */
static void GPIO_Init(void){
  GPIO_InitTypeDef GPIO_InitStruct = {0};
  /* GPIO Ports Clock Enable */
  __HAL_RCC_GPIOD_CLK_ENABLE();
  /* Configure GPIO pin Output Level */
  HAL_GPIO_WritePin(GPIOD, LD4_Pin|LD3_Pin|LD5_Pin|LD6_Pin, GPIO_PIN_RESET);
  /* Configure GPIO pins : LD4_Pin LD3_Pin LD5_Pin LD6_Pin*/
  GPIO_InitStruct.Pin = LD4_Pin|LD3_Pin|LD5_Pin|LD6_Pin;
  GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
  GPIO_InitStruct.Pull = GPIO_NOPULL;
  GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
  HAL_GPIO_Init(GPIOD, &GPIO_InitStruct);
}

/**
  * @brief  This function is executed in case of error occurrence.
  * @retval None
  */
void Error_Handler(void){
  __disable_irq();
  while (1){
    //Do nothing
  }
}