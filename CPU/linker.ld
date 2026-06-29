ENTRY( _start )

__stack_size = 1024;

PROVIDE( _stack_size = __stack_size );

MEMORY
{
	FLASH (rx) : ORIGIN = 0x00000000, LENGTH = 30K
	RAM (xrw) : ORIGIN = 0x20000000, LENGTH = 20K
}

SECTIONS
{
    /* Code and read-only data in FLASH */
    .text :
    {
        . = ALIGN(4);
        _stext = .;

        KEEP(*(.init))          /* reset handler */
        *(.text .text.*)
        *(.rodata .rodata.*)

        . = ALIGN(4);
        _etext = .;
    } > FLASH

    /* Initialized data: VMA in RAM, LMA in FLASH */
    .data : AT(_etext)
    {
        . = ALIGN(4);
        _sdata = .;

        *(.data .data.*)
        __sdata_start = .;
        *(.sdata .sdata.*)

        . = ALIGN(4);
        _edata = .;
    } > RAM

      _global_pointer = __sdata_start + 0x800;

    /* Zero-initialized data */
    .bss :
    {
        . = ALIGN(4);
        _sbss = .;

        *(.bss .bss.*)
        *(COMMON)

        . = ALIGN(4);
        _ebss = .;
    } > RAM

    /* End of RAM */
    _end = .;

    /* Stack at top of RAM */
    _stack_top = ORIGIN(RAM) + LENGTH(RAM);
}
