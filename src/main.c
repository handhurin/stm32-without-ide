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
#include <stm32f4xx.h>

#include "sysclock.h"

/************************** Constant Definitions *****************************/
#define LED4_PIN                         0x1000
#define LED3_PIN                         0x2000
#define LED5_PIN                         0x4000
#define LED6_PIN                         0x8000

/**************************** Type Definitions *******************************/

/************************** Function Prototypes ******************************/
int main(void);

/************************** Variable Definitions *****************************/

/************************* Functions Definitions *****************************/

int main(){

    clock_init();

    RCC->AHB1ENR |= (1 << RCC_AHB1ENR_GPIODEN_Pos);     /* Enable clock on PORTD	    */
    GPIOD->MODER |= (0x1 << (LED5_PIN*2));               /* Set LED pin as OUTPUT	    */
    GPIOD->ODR |= (1 << LED5_PIN);		                /* Set LED output to 1		    */

    while(1){
	    GPIOD->ODR ^= (1 << LED5_PIN);		            /* Toggle the led			    */	
	    delay_ms(500);                                  /* 500ms delay for 1Hz blinking */
    }
}