LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY InstractionMem IS
	PORT(
		
		address : IN  std_logic_vector(31 DOWNTO 0);
		dataout : OUT std_logic_vector(31 DOWNTO 0));
END ENTITY InstractionMem;

ARCHITECTURE ArchInstractionMem OF InstractionMem IS

	TYPE ram_type IS ARRAY(0 TO 255) OF std_logic_vector(15 DOWNTO 0);
	SIGNAL ram : ram_type ;
	
	BEGIN
		
		dataout <=ram(to_integer(unsigned(address)+1))& ram(to_integer(unsigned(address)));
END ArchInstractionMem;
