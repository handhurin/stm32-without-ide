ENTRY(Reset_Handler)

MEMORY
{
	FLASH(rx):ORIGIN =0x08000000,LENGTH =512K
	SRAM(rwx):ORIGIN =0x20000000,LENGTH =128K
}

SECTIONS
{
	.text :
	{
		*(.isr_vector)
		*(.text)
		*(.rodata)
		_etext = .;
	}> FLASH
	
      _la_data = LOADADDR(.data);

	.data :
	{
		_sdata = .;
		*(.data)
		_edata = .;
	}> SRAM AT> FLASH

	.bss :
	{
		_sbss = .;
		__bss_start__ = _sbss;
		*(.bss)
		_ebss = .;
		__bss_end__ = _ebss;
	}> SRAM
}