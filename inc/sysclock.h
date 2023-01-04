/**
 * @file sysclock.h
 * @author Kristian Klein
 * @brief Enable Clock (cf https://github.com/kristianklein/stm32-without-cubeide)
 * @date 31/10/2022
 * 
 * @copyright Copyright (c) 2022
 */
#ifndef SYSCLOCK_H
#define SYSCLOCK_H

/************************** Constant Definitions *****************************/

/**************************** Type Definitions *******************************/

/************************** Function Prototypes ******************************/

void clock_init();
void delay_ms(uint32_t milliseconds);

#endif /* SYSCLOCK_H */