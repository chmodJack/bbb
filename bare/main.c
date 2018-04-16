#include"types.h"
#include"macros.h"

void my_putchar(char chr)
{
	while(!(VALUE8(UART0_BASE+20) & (1<<5)));
		VALUE32(UART0_BASE)=chr;
}

int my_puts(const char *str)
{
	while(*str != '\0')
	{
		my_putchar('i');
		my_putchar(*str);
		str+=1;
	}

	if(*str == 0)
		my_putchar('z');

	return 0;
}

void my_print(void)
{
	my_putchar('H');
	my_putchar('e');
	my_putchar('l');
	my_putchar('l');
	my_putchar('o');
	my_putchar(' ');
	my_putchar('w');
	my_putchar('o');
	my_putchar('r');
	my_putchar('l');
	my_putchar('d');
	my_putchar('!');
	my_putchar('\r');
	my_putchar('\n');
}

char arr[]="Hello world@@";

int main(void)
{
	asm("bl disable_wdt");
	GPIO_INIT(0x40002,15<<21);

	float a,b,c;
	a=b/c;

	my_print();
	my_puts("Hello world?");

	while(1)
	{
		my_puts(arr);
		VALUE32(GPIO1_SETDATAOUT)=15<<21;
		DELAY(1500);

		VALUE32(GPIO1_CLEARDATAOUT)=15<<21;
		DELAY(1500);
	}
	return 0;
}
