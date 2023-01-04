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
#define LED_PIN    	    (5)		                /* 5 = PIN5 */

/**************************** Type Definitions *******************************/

/************************** Function Prototypes ******************************/
int main(void);

/************************** Variable Definitions *****************************/

/************************* Functions Definitions *****************************/

int main(){

    clock_init();

    RCC->AHB1ENR |= (1 << RCC_AHB1ENR_GPIOAEN_Pos);     /* Enable clock on PORTA	    */
    GPIOA->MODER |= (0x1 << (LED_PIN*2));               /* Set LED pin as OUTPUT	    */
    GPIOA->ODR |= (1 << LED_PIN);		                /* Set LED output to 1		    */

    while(1){
	    GPIOA->ODR ^= (1 << LED_PIN);		            /* Toggle the led			    */	
	    delay_ms(500);                                  /* 500ms delay for 1Hz blinking */
    }
}