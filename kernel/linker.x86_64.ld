OUTPUT_FORMAT("elf64-x86-64")
ENTRY(_start)

SECTIONS
{
	.text 0x8020:
	{
		*(.text .stub .text.*)
	}

	.rodata:
	{
		*(.rodata .rodata.*)
	}
	.rodata1:
	{
		*(.rodata1)
	}

	. = ALIGN(512);

	.data:
	{
		*(.data .data.*)
		SORT(CONSTRUCTORS)
	}
	.data1:
	{
		*(.data1)
	}

	.bss:
	{
		*(.dynbss)
		*(.bss .bss.*)
		*(COMMON)
		. = ALIGN(. != 0 ? 64 / 8 : 1);
	}
}