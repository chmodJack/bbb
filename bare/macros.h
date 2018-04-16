#ifndef __MACROS_H__
#define __MACROS_H__

//LED GPIO1 21 22 23 24

#define GPIO0_BASE 0x44E07000
#define GPIO1_BASE 0x4804C000
#define GPIO2_BASE 0x481AC000
#define GPIO3_BASE 0x481AE000

#define GPIO_REVISION        0x000
#define GPIO_SYSCONFIG       0x010
#define GPIO_EOI             0x020
#define GPIO_IRQSTATUS_RAW_0 0x024
#define GPIO_IRQSTATUS_RAW_1 0x028
#define GPIO_IRQSTATUS_0     0x02C
#define GPIO_IRQSTATUS_1     0x030
#define GPIO_IRQSTATUS_SET_0 0x034
#define GPIO_IRQSTATUS_SET_1 0x038
#define GPIO_IRQSTATUS_CLR_0 0x03C
#define GPIO_IRQSTATUS_CLR_1 0x040
#define GPIO_IRQWAKEN_0      0x044
#define GPIO_IRQWAKEN_1      0x048
#define GPIO_SYSSTATUS       0x114
#define GPIO_CTRL            0x130
#define GPIO_OE              0x134
#define GPIO_DATAIN          0x138
#define GPIO_DATAOUT         0x13C
#define GPIO_LEVELDETECT0    0x140
#define GPIO_LEVELDETECT1    0x144
#define GPIO_RISINGDETECT    0x148
#define GPIO_FALLINGDETECT   0x14C
#define GPIO_DEBOUNCENABLE   0x150
#define GPIO_DEBOUNCINGTIME  0x154
#define GPIO_CLEARDATAOUT    0x190
#define GPIO_SETDATAOUT      0x194

#define CM_PER_GPIO1_CLKCTRL  0x44e000AC
#define GPIO1_OE              0x4804C134
#define GPIO1_SETDATAOUT      0x4804C194
#define GPIO1_CLEARDATAOUT    0x4804C190
#define WDT_BASE              0x44E35000

#define CONF_UART0_RXD        0x44E10970
#define CONF_UART0_TXD        0x44E10974
#define CM_WKUP_CLKSTCTRL     0x44E00400
#define CM_PER_L4HS_CLKSTCTRL 0x44E0011C
#define CM_WKUP_UART0_CLKCTRL 0x44E004B4
#define CM_PER_UART0_CLKCTRL  0x44E0006C
#define UART0_SYSC			  0x44E09054
#define UART0_SYSS			  0x44E09058
#define UART0_BASE			  0x44E09000

////////////////////////////////////////

#define VALUE8(addr)  (*((volatile uint8_t*)(addr)))
#define VALUE32(addr) (*((volatile uint32_t*)(addr)))

#define GPIO_INIT(clock,outenable) VALUE32(CM_PER_GPIO1_CLKCTRL) = clock;\
									   VALUE32(GPIO1_OE) = VALUE32(GPIO1_OE) & ~(outenable);

#define DELAY(n) for(uint32_t i=0;i<n;i++)\
					for(uint32_t j=0;j<n;j++);

////////////////////////////////////////

#define NON_SECURE_SRAM_IMG_END 0x4030B800
#define SZ_1K               0x00000400
#define SRAM_SCRATCH_SPACE_ADDR (NON_SECURE_SRAM_IMG_END - SZ_1K)
#define OMAP_SRAM_SCRATCH_BOOT_PARAMS   (SRAM_SCRATCH_SPACE_ADDR + 0x24)

#endif//__MACROS_H__
