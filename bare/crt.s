//Set up initial C runtime environment and call board_init_f(0)
.global _main
_main:
	ldr sp,=0x4030ff20
	bic sp,sp,#7

	bl main

	bl board_init_f_alloc_reserve
	mov sp,r0
	//set up gd here, outside any C code
	mov r9,r0
	bl board_init_f_init_reserve
	//call board_init_f(0)
	mov r0,#0
	bl board_init_f
	bl main

.global board_init_f_alloc_reserve
board_init_f_alloc_reserve:
	ldr r1,=1240
	sub r0,r0,r1
	bic r0,r0,#15
	mov pc,lr
.global board_init_f_init_reserve
board_init_f_init_reserve:
	push {r4, lr}
	movs r2, #216
	movs r1, #0
	mov r4, r0
	bl memset
	adds r4, #224
	str  r4, [r9, #148]
	pop {r4, pc}
.global board_init_f
board_init_f:
	mov pc,lr
	//这个r3是为了帧8字节对其
	push {r3,lr}

	//bl hw_data_init
	//bl early_system_init
	//bl board_early_init_f
	//bl sdram_init

	str r0,[r9,#4]
	movs r2,#0
	str r2,[r9,#28]
	ldr r0,=0x8083c12c
	//bl initcall_run_list
	//if return value is not zero, hang.
	cmp r0,#0
	bne .
	pop {r3,pc}

.global hw_data_init
hw_data_init:
	ldr r3,=0x8084f620
	ldr r2,=0x8083b820
	str r2,[r3]
	mov pc,lr
