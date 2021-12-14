LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY DataMEM IS
	PORT(
		clk : IN std_logic;
		MW32  : IN std_logic;
        MW16  : IN std_logic;
		address : IN  std_logic_vector(31 DOWNTO 0);
		data_16bits : IN  std_logic_vector(15 DOWNTO 0);
		data_32bits : IN  std_logic_vector(31 DOWNTO 0);

		dataout : OUT std_logic_vector(31 DOWNTO 0));
END ENTITY DataMEM;

ARCHITECTURE ArchDataMEM OF DataMEM IS

	TYPE ram_type IS ARRAY(0 TO 255) OF std_logic_vector(15 DOWNTO 0);
	SIGNAL ram : ram_type ;
	
	BEGIN
		PROCESS(clk) IS
		BEGIN
			IF rising_edge(clk) THEN  
				IF MW32 = '1' THEN
					ram(to_integer(unsigned(address))) <= data_32bits(15 DOWNTO 0);
                        		ram(to_integer(unsigned(address)+1)) <= data_32bits(31 DOWNTO 16);
				END IF;
                    		IF MW16 = '1' THEN
					ram(to_integer(unsigned(address))) <= data_16bits;
                       
				END IF;
			END IF;
		END PROCESS;
		dataout <=ram(to_integer(unsigned(address)+1)) &ram(to_integer(unsigned(address)));
END ArchDataMEM;
