.global _start
.section .vectors,"ax"
_start:
	b reset
	ldr	pc,_undefined_instruction
	ldr	pc,_software_interrupt
	ldr	pc,_prefetch_abort
	ldr	pc,_data_abort
	ldr	pc,_not_used
	ldr	pc,_irq
	ldr	pc,_fiq

_undefined_instruction:.word undefined_instruction
_software_interrupt:   .word software_interrupt
_prefetch_abort:       .word prefetch_abort
_data_abort:           .word data_abort
_not_used:             .word not_used
_irq:                  .word irq
_fiq:                  .word fiq
                       .word 0xdeadbeef

.global undefined_instruction
undefined_instruction:
	b .
.global software_interrupt
software_interrupt:
	b .
.global prefetch_abort
prefetch_abort:
	b .
.global data_abort
data_abort:
	b .
.global not_used
not_used:
	b .
.global irq
irq:
	b .
.global fiq
fiq:
	b .

.global reset
.section .text
reset:
save_boot_params:
	ldr r1,=0x4030b424
	str r0,[r1]
save_boot_params_ret:
	//disable interrupts (FIQ and IRQ), also set the cpu to SVC32 mode,
	mrs   r0,   cpsr
	and   r1,   r0,   #0x1f  //mask mode bits
	teq   r1,   #0x1a        //test for HYP mode
	bicne r0,   r0,   #0x1f  //clear all mode bits
	orrne r0,   r0,   #0x13  //set SVC mode
	orr   r0,   r0,   #0xc0  //disable FIQ and IRQ
	msr   cpsr, r0
	//Set V=0 in CP15 SCTLR register - for VBAR to point to vector
	mrc p15,0,r0,c1,c0,0   //Read CP15 SCTLR Register
	bic r0,#(1<<13)
	mcr p15,0,r0,c1,c0,0   //Write CP15 SCTLR Register
	//Set vector address in CP15 VBAR register
	ldr r0,=_start
	mcr p15,0,r0,c12,c0,0  //Set VBAR

	bl cpu_init_cp15
	bl cpu_init_crit
	bl _main

//Setup CP15 registers (cache, MMU, TLBs). The I-cache is turned on unless
.global cpu_init_cp15
cpu_init_cp15:
	//invalidate L1 I/D
	mov r0, #0                  //set up for MCR
	mcr p15, 0, r0, c8, c7, 0   //invalidate TLBs
	mcr p15, 0, r0, c7, c5, 0   //invalidate icache
	mcr p15, 0, r0, c7, c5, 6   //invalidate BP array
	mcr p15, 0, r0, c7, c10, 4  //DSB
	mcr p15, 0, r0, c7, c5,  4  //ISB
	//disable MMU stuff and caches
	mrc p15, 0, r0, c1, c0, 0
	bic	r0, r0, #0x00002000	    //clear bits 13 (--V-)
	bic	r0, r0, #0x00000007	    //clear bits 2:0 (-CAM)
	orr	r0, r0, #0x00000002	    //set bit 1 (--A-) Align
	orr	r0, r0, #0x00000800	    //set bit 11 (Z---) BTB
	orr	r0, r0, #0x00001000	    //set bit 12 (I) I-cache
	mcr	p15, 0, r0, c1, c0, 0

	mov	r5, lr			        //Store my Caller
	mrc	p15, 0, r1, c0, c0, 0	//r1 has Read Main ID Register (MIDR)
	mov	r3, r1, lsr #20		    //get variant field
	and	r3, r3, #0xf		    //r3 has CPU variant
	and	r4, r1, #0xf		    //r4 has CPU revision
	mov	r2, r3, lsl #4		    //shift variant field for combined value
	orr	r2, r4, r2		        //r2 has combined CPU variant + revision
	mov pc,r5
//Jump to board specific initialization...
//The Mask ROM will have already initialized
//basic memory. Go here to bump up clock rate and handle
//wake up conditions.
.global cpu_init_crit
cpu_init_crit:
	//sp==SRAM_STACK
	ldr sp,=0x4030ff20
	bic sp,sp,#7
	mov r9,#0
	mov pc,lr
