LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY DataMEM IS
	PORT(
		clk : IN std_logic;
		
		MW32  : IN std_logic;
        MW16  : IN std_logic;
		MR : in std_logic;
		address : IN  std_logic_vector(31 DOWNTO 0);
		data_16bits : IN  std_logic_vector(15 DOWNTO 0);
		data_32bits : IN  std_logic_vector(31 DOWNTO 0);

		dataout : OUT std_logic_vector(31 DOWNTO 0));
END ENTITY DataMEM;

ARCHITECTURE ArchDataMEM OF DataMEM IS

	TYPE ram_type_memo IS ARRAY(0 TO 1048575) OF std_logic_vector(15 DOWNTO 0);
	SIGNAL ram_arr : ram_type_memo ;
	
	BEGIN
		PROCESS(clk) IS
		BEGIN
			IF rising_edge(clk) THEN  
				IF MW32 = '1' THEN
					ram_arr(to_integer(unsigned(address))) <= data_32bits(31 DOWNTO 16);
                    ram_arr(to_integer(to_unsigned(to_integer(unsigned(address))+1048575,20))) <= data_32bits(15 DOWNTO 0);
				END IF;
                IF MW16 = '1' THEN

					ram_arr(to_integer(unsigned(address))) <= data_16bits;
                       
				END IF;
			end IF ;


			IF falling_edge(clk) THEN
				IF MR = '1' THEN

				dataout <=ram_arr(to_integer(unsigned(address))) & ram_arr(to_integer(to_unsigned(to_integer(unsigned(address))+1048575,20)));
				   
				END IF;
				IF MR = '0' THEN

				dataout <=x"00000000";
				   
				END IF;

			END IF;


		END PROCESS;
END ArchDataMEM;
