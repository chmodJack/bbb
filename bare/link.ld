ENTRY(_start)
MEMORY
{
	RAM(rwx) : ORIGIN = 0x80800000 , LENGTH = 512M
}
SECTIONS
{
	.text :
	{
		*(.vectors)
		*(.text*)
	} > RAM

	. = ALIGN(4);

	.rodata :
	{
		*(.rodata*)
	}

	. = ALIGN(4);

	.data :
	{
		*(.data*)
	}

	. = ALIGN(4);

	_sbss = .;

	.bss :
	{
		*(.bss*)
	} > RAM

	. = ALIGN(4);

	_ebss = .;
}
