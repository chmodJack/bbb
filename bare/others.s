/********************************************************
  WDT disable sequence (see TRM 20.4.3.8):
  1- Write XXXX AAAAh in WDT_WSPR.
  2- Poll for posted write to complete using WDT_WWPS.W_PEND_WSPR. (bit 4)
  3- Write XXXX 5555h in WDT_WSPR.
  4- Poll for posted write to complete using WDT_WWPS.W_PEND_WSPR. (bit 4)

  Registers (see TRM 20.4.4.1):
  WDT_BASE -> 0x44E35000
  WDT_WSPR -> 0x44E35048
  WDT_WWPS -> 0x44E35034
 ********************************************************/
.equ WDT_BASE,0x44E35000
.global disable_wdt
disable_wdt:
	stmfd sp!,{r0-r1,lr}
	ldr r0, =WDT_BASE

	ldr r1, =0xAAAA
	str r1, [r0, #0x48]
	bl poll_wdt_write

	ldr r1, =0x5555
	str r1, [r0, #0x48]
	bl poll_wdt_write

	ldmfd sp!,{r0-r1,pc}

poll_wdt_write:
	ldr r1, [r0, #0x34]
	and r1, r1, #(1<<4)
	cmp r1, #0
	bne poll_wdt_write
	bx lr

/*
   Outputs alphabet over serial.
 */

.equ CM_PER_GPIO1_CLKCTRL, 0x44e000AC
.equ GPIO1_OE, 0x4804C134
.equ GPIO1_SETDATAOUT, 0x4804C194
.equ CONF_UART0_RXD, 0x44E10970
.equ CONF_UART0_TXD, 0x44E10974
.equ CM_WKUP_CLKSTCTRL, 0x44E00400
.equ CM_PER_L4HS_CLKSTCTRL, 0x44E0011C
.equ CM_WKUP_UART0_CLKCTRL, 0x44E004B4
.equ CM_PER_UART0_CLKCTRL, 0x44E0006C
.equ UART0_SYSC, 0x44E09054
.equ UART0_SYSS, 0x44E09058
.equ UART0_BASE, 0x44E09000

.global __start
__start:
	/* set uart mux config */
	ldr r0, =CONF_UART0_RXD
	ldr r1, =(0x1<<4)|(0x1<<5)
	str r1, [r0]
	ldr r0, =CONF_UART0_TXD
	ldr r1, =0x0
	str r1, [r0]

	/* setup_clocks_for_console */
	ldr r0, =CM_WKUP_CLKSTCTRL
	ldr r1, [r0]
	and r1, #~0x3
	orr r1, #0x2
	str r1, [r0]
	ldr r0, =CM_PER_L4HS_CLKSTCTRL
	ldr r1, [r0]
	and r1, #~0x3
	orr r1, #0x2
	str r1, [r0]
	ldr r0, =CM_WKUP_UART0_CLKCTRL
	ldr r1, [r0]
	and r1, #~0x3
	orr r1, #0x2
	str r1, [r0]
	ldr r0, =CM_PER_UART0_CLKCTRL
	ldr r1, [r0]
	and r1, #~0x3
	orr r1, #0x2
	str r1, [r0]

	/* UART soft reset */
	ldr r0, =UART0_SYSC
	ldr r1, [r0]
	orr r1, #0x2
	str r1, [r0]
	ldr r0, =UART0_SYSS

	/*
	   uart_soft_reset:
	   ldr r1, [r0]
	   ands r1, #0x1
	   beq uart_soft_reset
	 */

	/* turn off smart idle */
	ldr r0, =UART0_SYSC
	ldr r1, [r0]
	orr r1, #(0x1 << 0x3)
	str r1, [r0]

	/* initialize UART */
	ldr r0, =UART0_BASE
	ldr r1, =26
	uart_init:
	ldrb    r3, [r0, #20]
	uxtb    r3, r3
	tst     r3, #0x40
	beq     uart_init
	mov     r3, #0
	strb    r3, [r0, #4]
	mov     r3, #7
	strb    r3, [r0, #32]
	mvn     r3, #0x7c
	strb    r3, [r0, #12]
	mov     r3, #0
	strb    r3, [r0]
	strb    r3, [r0, #4]
	mov     r3, #3
	strb    r3, [r0, #12]
	strb    r3, [r0, #16]
	mov     r3, #7
	strb    r3, [r0, #8]
	mvn     r3, #0x7c
	strb    r3, [r0, #12]
	uxtb    r3, r1
	strb    r3, [r0]
	ubfx    r1, r1, #8, #8
	strb    r1, [r0, #4]
	mov     r3, #3
	strb    r3, [r0, #12]
	mov     r3, #0
	strb    r3, [r0, #32]

.global uart_loop
uart_loop:
	ldr     r1, =UART0_BASE
	ldr     r0, ='A'
	loop:
	cmp     r0, #'Z'
	movgt   r0, #'A'
	bl uart_putc
	mov     r3, r0
	ldr     r0, ='\r'
	bl uart_putc
	ldr     r0, ='\n'
	bl uart_putc
	mov     r0, r3
	add     r0, #1
	b loop

.global uart_putc
uart_putc:
	ldrb    r2, [r1, #20]
	uxtb    r2, r2
	tst     r2, #(1<<5)
	beq     uart_putc
	strb    r0, [r1]
	bx      lr
