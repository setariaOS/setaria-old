OUTPUT_FORMAT("elf64-x86-64")

SECTIONS
{
	PROVIDE(__executable_start = 0x400000);
	. = 0x400000 + SIZEOF_HEADERS;

	.text 0x8020:
	{
		*(.text .stub .text.* .gnu.linkonce.t.*)
		*(.gnu.warning)
	} = 0x90909090

	.rodata : { *(.rodata .rodata.* .gnu.linkonce.r.*) }
	.rodata1 : { *(.rodata1) }

	. = ALIGN(512);
	.data :
	{
		*(.data .data.* .gnu.linkonce.d.*)
		SORT(CONSTRUCTORS)
	}
	.data1 : { *(.data1) }

	__bss_start = .;
	.bss :
	{
		*(.dynbss)
		*(.bss .bss.* .gnu.linkonce.b.*)
		*(COMMON)

		. = ALIGN(. != 0 ? 64 / 8 : 1);
	}

/*********************************************************************************/

	.interp : { *(.interp) }
	.note.gnu.build-id : { *(.note.gnu.build-id) }
	.hash : { *(.hash) }
	.gnu.hash : { *(.gnu.hash) }
	.dynsym : { *(.dynsym) }
	.dynstr : { *(.dynstr) }
	.gnu.version : { *(.gnu.version) }
	.gnu.version_d : { *(.gnu.version_d) }
	.gnu.version_r : { *(.gnu.version_r) }
	.rel.init : { *(.rel.init) }
	.rela.init : { *(.rela.init) }
	.rel.text : { *(.rel.text .rel.text.* .rel.gnu.linkonce.t.*) }
	.rela.text : { *(.rela.text .rela.text.* .rela.gnu.linkonce.t.*) }
	.rel.fini : { *(.rel.fini) }
	.rela.fini : { *(.rela.fini) }
	.rel.rodata : { *(.rel.rodata .rel.rodata.* .rel.gnu.linkonce.r.*) }
	.rela.rodata : { *(.rela.rodata .rela.rodata.* .rela.gnu.linkonce.r.*) }
	.rel.data.rel.ro : { *(.rel.data.rel.ro* .rel.gnu.linkonce.d.rel.ro.*) }
	.rela.data.rel.ro : { *(.rela.data.rel.ro* .rela.gnu.linkonce.d.rel.ro.*) }
	.rel.data : { *(.rel.data .rel.data.* .rel.gnu.linkonce.d.*) }
	.rela.data : { *(.rela.data .rela.data.* .rela.gnu.linkonce.d.*) }
	.rel.tdata : { *(.rel.tdata .rel.tdata.* .rel.gnu.linkonce.td.*) }
	.rela.tdata : { *(.rela.tdata .rela.tdata.* .rela.gnu.linkonce.td.*) }
	.rel.tbss : { *(.rel.tbss .rel.tbss.* .rel.gnu.linkonce.tb.*) }
	.rela.tbss : { *(.rela.tbss .rela.tbss.* .rela.gnu.linkonce.tb.*) }
	.rel.ctors : { *(.rel.ctors) }
	.rela.ctors : { *(.rela.ctors) }
	.rel.dtors : { *(.rel.dtors) }
	.rela.dtors : { *(.rela.dtors) }
	.rel.got : { *(.rel.got) }
	.rela.got : { *(.rela.got) }
	.rel.bss : { *(.rel.bss .rel.bss.* .rel.gnu.linkonce.b.*) }
	.rela.bss : { *(.rela.bss .rela.bss.* .rela.gnu.linkonce.b.*) }
	.rel.ldata : { *(.rel.ldata .rel.ldata.* .rel.gnu.linkonce.l.*) }
	.rela.ldata : { *(.rela.ldata .rela.ldata.* .rela.gnu.linkonce.l.*) }
	.rel.lbss : { *(.rel.lbss .rel.lbss.* .rel.gnu.linkonce.lb.*) }
	.rela.lbss : { *(.rela.lbss .rela.lbss.* .rela.gnu.linkonce.lb.*) }
	.rel.lrodata : { *(.rel.lrodata .rel.lrodata.* .rel.gnu.linkonce.lr.*) }
	.rela.lrodata : { *(.rela.lrodata .rela.lrodata.* .rela.gnu.linkonce.lr.*) }
	.rel.plt : { *(.rel.plt) }
	.rela.plt : { *(.rela.plt) }

	.init :
	{
		KEEP(*(.init))
	} = 0x90909090
	.plt : { *(.plt) }
	.fini :
	{
		KEEP(*(.fini))
	} = 0x90909090

	PROVIDE(__etext = .);
	PROVIDE(_etext = .);
	PROVIDE(etext = .);

	.eh_frame_hdr : { *(.eh_frame_hdr) }
	.eh_frame : ONLY_IF_RO { KEEP(*(.eh_frame)) }
	.gcc_except_table : ONLY_IF_RO { *(.gcc_except_table .gcc_except_table.*) }

	. = ALIGN(CONSTANT(MAXPAGESIZE)) - ((CONSTANT(MAXPAGESIZE) - .) & (CONSTANT(MAXPAGESIZE) - 1));
	. = DATA_SEGMENT_ALIGN(CONSTANT(MAXPAGESIZE), CONSTANT(COMMONPAGESIZE));

	.eh_frame : ONLY_IF_RW { KEEP(*(.eh_frame)) }
	.gcc_except_table : ONLY_IF_RW { *(.gcc_except_table .gcc_except_table.*) }

	.tdata : { *(.tdata .tdata.* .gnu.linkonce.td.*) }
	.tbss : { *(.tbss .tbss.* .gnu.linkonce.tb.*) *(.tcommon) }
	.preinit_array :
	{
		PROVIDE_HIDDEN(__preinit_array_start = .);
		KEEP(*(.preinit_array))
		PROVIDE_HIDDEN(__preinit_array_end = .);
	}
	.init_array :
	{
		 PROVIDE_HIDDEN(__init_array_start = .);
		 KEEP(*(SORT(.init_array.*)))
		 KEEP(*(.init_array))
		 PROVIDE_HIDDEN(__init_array_end = .);
	}
	.fini_array :
	{
		PROVIDE_HIDDEN(__fini_array_start = .);
		KEEP(*(.fini_array))
		KEEP(*(SORT(.fini_array.*)))
		PROVIDE_HIDDEN(__fini_array_end = .);
	}

	.ctors :
	{
		KEEP(*crtbegin.o(.ctors))
		KEEP(*crtbegin?.o(.ctors))

		KEEP(*(EXCLUDE_FILE(*crtend.o *crtend?.o ) .ctors))
		KEEP(*(SORT(.ctors.*)))
		KEEP(*(.ctors))
	}
	.dtors :
	{
		KEEP(*crtbegin.o(.dtors))
		KEEP(*crtbegin?.o(.dtors))
		KEEP(*(EXCLUDE_FILE(*crtend.o *crtend?.o ) .dtors))
		KEEP(*(SORT(.dtors.*)))
		KEEP(*(.dtors))
	}
	.jcr : { KEEP(*(.jcr)) }
	.data.rel.ro : { *(.data.rel.ro.local* .gnu.linkonce.d.rel.ro.local.*) *(.data.rel.ro* .gnu.linkonce.d.rel.ro.*) }
	.dynamic : { *(.dynamic) }
	.got : { *(.got) }

	. = DATA_SEGMENT_RELRO_END(24, .);
	.got.plt : { *(.got.plt) }

	_edata = .;
	PROVIDE(edata = .);

/*********************************************************************************/

	.lbss :
	{
		*(.dynlbss)
		*(.lbss .lbss.* .gnu.linkonce.lb.*)
		*(LARGE_COMMON)
	}

	. = ALIGN(64 / 8);
	.lrodata ALIGN(CONSTANT(MAXPAGESIZE)) + (. & (CONSTANT(MAXPAGESIZE) - 1)):
	{
		*(.lrodata .lrodata.* .gnu.linkonce.lr.*)
	}
	.ldata ALIGN(CONSTANT(MAXPAGESIZE)) + (. & (CONSTANT(MAXPAGESIZE) - 1)):
	{
		*(.ldata .ldata.* .gnu.linkonce.l.*)
		. = ALIGN(. != 0 ? 64 / 8 : 1);
	}

	. = ALIGN(64 / 8);
	_end = .;
	PROVIDE(end = .);

	. = DATA_SEGMENT_END(.);
	.stab 0 : { *(.stab) }
	.stabstr 0 : { *(.stabstr) }
	.stab.excl 0 : { *(.stab.excl) }
	.stab.exclstr 0 : { *(.stab.exclstr) }
	.stab.index 0 : { *(.stab.index) }
	.stab.indexstr 0 : { *(.stab.indexstr) }
	.comment 0 : { *(.comment) }

	.debug 0 : { *(.debug) }
	.line 0 : { *(.line) }

	.debug_srcinfo 0 : { *(.debug_srcinfo) }
	.debug_sfnames 0 : { *(.debug_sfnames) }

	.debug_aranges 0 : { *(.debug_aranges) }
	.debug_pubnames 0 : { *(.debug_pubnames) }

	.debug_info 0 : { *(.debug_info .gnu.linkonce.wi.*) }
	.debug_abbrev 0 : { *(.debug_abbrev) }
	.debug_line 0 : { *(.debug_line) }
	.debug_frame 0 : { *(.debug_frame) }
	.debug_str 0 : { *(.debug_str) }
	.debug_loc 0 : { *(.debug_loc) }
	.debug_macinfo 0 : { *(.debug_macinfo) }

	.debug_weaknames 0 : { *(.debug_weaknames) }
	.debug_funcnames 0 : { *(.debug_funcnames) }
	.debug_typenames 0 : { *(.debug_typenames) }
	.debug_varnames	0 : { *(.debug_varnames) }

	.debug_pubtypes 0 : { *(.debug_pubtypes) }
	.debug_ranges 0 : { *(.debug_ranges) }
	.gnu.attributes 0 : { KEEP(*(.gnu.attributes)) }
	/DISCARD/ : { *(.note.GNU-stack) *(.gnu_debuglink) }
}