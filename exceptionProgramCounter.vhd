LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY ExceptionProgramCounter IS
	PORT(
		clk : IN std_logic;
		reset: IN std_logic;
		EPC_Enable  : IN std_logic;
        EPC_data  : INOUT std_logic_vector(31 DOWNTO 0);
        Instruction_data : IN std_logic_vector(31 DOWNTO 0)
	);
END ENTITY ExceptionProgramCounter;

ARCHITECTURE Arch_ExceptionProgramCounter OF ExceptionProgramCounter IS
BEGIN
		PROCESS(clk,reset) IS
		BEGIN
			IF (reset = '1') THEN
                EPC_data <= "00000000000000000000000000000000";
			END IF;
			IF rising_edge(clk) THEN  
				IF (EPC_Enable = '1') THEN
                    EPC_data <= Instruction_data;
				ELSE
                    EPC_data <= EPC_data;
				END IF;
			END IF;
		END PROCESS;
END Arch_ExceptionProgramCounter;

