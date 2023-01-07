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

#include "main.h"
#include "sysclock.h"

/************************** Constant Definitions *****************************/
#define LED3_PIN                         13U
#define LED4_PIN                         12U
#define LED5_PIN                         14U
#define LED6_PIN                         15U

/**************************** Type Definitions *******************************/

/************************** Function Prototypes ******************************/

/************************** Variable Definitions *****************************/

/************************* Functions Definitions *****************************/

int main(void){
    clock_init();

    RCC->AHB1ENR |= (1 << RCC_AHB1ENR_GPIODEN_Pos);     /* Enable clock on PORTD	    */
    
    GPIOD->MODER |= (0x1 << (LED4_PIN*2));               /* Set LED4 pin as OUTPUT	    */
    GPIOD->MODER |= (0x1 << (LED5_PIN*2));               /* Set LED5 pin as OUTPUT	    */
    GPIOD->MODER |= (0x1 << (LED3_PIN*2));               /* Set LED4 pin as OUTPUT	    */
    GPIOD->MODER |= (0x1 << (LED6_PIN*2));               /* Set LED5 pin as OUTPUT	    */

    GPIOD->ODR |= (1 << LED4_PIN);		                /* Set LED4 output to 1		    */
    GPIOD->ODR |= (1 << LED5_PIN);		                /* Set LED5 output to 1		    */
    GPIOD->ODR |= (0 << LED3_PIN);		                /* Set LED3 output to 0		    */
    GPIOD->ODR |= (0 << LED6_PIN);		                /* Set LED6 output to 0		    */

    while(1){
        GPIOD->ODR ^= (1 << LED4_PIN);		            /* Toggle LED4		    	    */	
	    GPIOD->ODR ^= (1 << LED5_PIN);		            /* Toggle LED5		    	    */
        GPIOD->ODR ^= (1 << LED3_PIN);		            /* Toggle LED3		    	    */	
	    GPIOD->ODR ^= (1 << LED6_PIN);		            /* Toggle LED6		    	    */	
        HAL_Delay(500);	
	    //delay_ms(500);                                  /* 500ms delay for 1Hz blinking */
    }
}