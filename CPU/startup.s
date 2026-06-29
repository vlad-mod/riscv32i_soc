/********************************** (C) COPYRIGHT *******************************
 * File Name          : startup_ch57x.s
 * Author             : WCH
 * Version            : V1.0.0
 * Date               : 2020/04/30
 * Description        :
 *********************************************************************************
 * Copyright (c) 2021 Nanjing Qinheng Microelectronics Co., Ltd.
 * Attention: This software (modified or not) and binary are used for
 * microcontroller manufactured by Nanjing Qinheng Microelectronics.
 *******************************************************************************/
    .option norvc
	.section .init
	.global	_start
	.align	2
_start:
	j	handle_reset
    j	handle_reset
    .word   0
    .word   0
        j   NMI_Handler                 /* NMI Handler */
        j   HardFault_Handler           /* Hard Fault Handler */
    .word   0
    .word   0
    .word   0
    .word   0
    .word   0
    .word   0
    .word   0
    .word   0
        j   SysTick_Handler            /* SysTick Handler */
    .word   0
        j   SW_Handler                 /* SW Handler */
    .word   0
    /* External Interrupts */
        j   TMR0_IRQHandler            /* 0:  TMR0 */
        j   GPIOA_IRQHandler           /* GPIOA */
        j   GPIOB_IRQHandler           /* GPIOB */
        j   SPI0_IRQHandler            /* SPI0 */
        j   BB_IRQHandler              /* BLEB */
        j   LLE_IRQHandler             /* BLEL */
        j   USB_IRQHandler             /* USB */
        .word   0
        j   TMR1_IRQHandler            /* TMR1 */
        j   TMR2_IRQHandler            /* TMR2 */
        j   UART0_IRQHandler           /* UART0 */
        j   UART1_IRQHandler           /* UART1 */
        j   RTC_IRQHandler             /* RTC */
        j   ADC_IRQHandler             /* ADC */
        .word   0
        j   PWMX_IRQHandler            /* PWMX */
        j   TMR3_IRQHandler            /* TMR3 */
        j   UART2_IRQHandler           /* UART2 */
        j   UART3_IRQHandler           /* UART3 */
        j   WDOG_BAT_IRQHandler        /* WDOG_BAT */



    .weak   NMI_Handler
    .weak   HardFault_Handler
    .weak   SysTick_Handler
    .weak   SW_Handler
    .weak   TMR0_IRQHandler
    .weak   GPIOA_IRQHandler
    .weak   GPIOB_IRQHandler
    .weak   SPI0_IRQHandler
    .weak   BB_IRQHandler
    .weak   LLE_IRQHandler
    .weak   USB_IRQHandler
    .weak   TMR1_IRQHandler
    .weak   TMR2_IRQHandler
    .weak   UART0_IRQHandler
    .weak   UART1_IRQHandler
    .weak   RTC_IRQHandler
    .weak   ADC_IRQHandler
    .weak   PWMX_IRQHandler
    .weak   TMR3_IRQHandler
    .weak   UART2_IRQHandler
    .weak   UART3_IRQHandler
    .weak   WDOG_BAT_IRQHandler

NMI_Handler:  1:  j 1b
HardFault_Handler:  1:  j 1b
SysTick_Handler:  1:  j 1b
SW_Handler:  1:  j 1b
TMR0_IRQHandler:  1:  j 1b
GPIOA_IRQHandler:  1:  j 1b
GPIOB_IRQHandler:  1:  j 1b
SPI0_IRQHandler:  1:  j 1b
BB_IRQHandler:  1:  j 1b
LLE_IRQHandler:  1:  j 1b
USB_IRQHandler:  1:  j 1b
TMR1_IRQHandler:  1:  j 1b
TMR2_IRQHandler:  1:  j 1b
UART0_IRQHandler:  1:  j 1b
UART1_IRQHandler:  1:  j 1b
RTC_IRQHandler:  1:  j 1b
ADC_IRQHandler:  1:  j 1b
PWMX_IRQHandler:  1:  j 1b
TMR3_IRQHandler:  1:  j 1b
UART2_IRQHandler:  1:  j 1b
UART3_IRQHandler:  1:  j 1b
WDOG_BAT_IRQHandler:  1:  j 1b

handle_reset:
# warm up cache and memory system
    lui   a1, 0x20000
    lw   x0, 0(a1)
    lw   x0, 4(a1)
    lw   x0, 8(a1)
    sw   x0, 0(a1)
    sw   x0, 4(a1)
    sw   x0, 8(a1)
    add  a1, x0, x0
#1:
#    li    a5,0
#    lui   a4, 0x10000        # x10 = 0x20000000
#    lui   a1, 0x20000
#lo:
#    lw a5, 4(a1)
#    addi a5, a5,1
#    sw a5, 4(a1)
   # addi a5, a5,1
   # lw a5, 4(a1)

#    sw a5, 0(a4)
#end:
#    j lo
#    lw    x0, 0(a1)          # load word from 0x20000000 into x5
#    lw    x0, 4(a1)          # load word from 0x20000004 into x6
#    lw    x0, 0(a1)          # load word from 0x20000000 into x5


    la gp, _global_pointer
	la sp, _stack_top


/* Load data section from flash to RAM */
    la  a0, _etext     /* source (FLASH) */
    la  a1, _sdata     /* destination (RAM) */
    la  a2, _edata     /* end of .data */

1:
    beq a1, a2, 2f
    lw  t0, 0(a0)
    sw  t0, 0(a1)
    addi a0, a0, 4
    addi a1, a1, 4
    j   1b

2:
	/* clear bss section */
	la a0, _sbss
	la a1, _ebss
	bgeu a0, a1, 2f
1:
	sw zero, (a0)
	addi a0, a0, 4
	bltu a0, a1, 1b
2:
      la t0, main
      jr t0

	/* enable vector relocation
	li t0, 0xE000ED14
	li t1, 1
	sw t1, 0(t0)*/

	mret


