//Set up initial C runtime environment and call board_init_f(0)
.global _main
_main:
	ldr sp,=0x4030ff20
	bic sp,sp,#7
	bl board_init_f_alloc_reserve
	mov sp,r0
	//set up gd here, outside any C code
	mov r9,r0
	bl board_init_f_init_reserve
	//call board_init_f(0)
	mov r0,#0
	bl board_init_f

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
	push {r3,lr}
	str r0,[r9,#4]
	movs r2,#0
	str r2,[r9,#28]
	ldr r0,=0x8083c12c
	bl initcall_run_list
	//if return value is not zero, hang.
	cmp r0,#0
	bne .
	pop {r3,pc}
