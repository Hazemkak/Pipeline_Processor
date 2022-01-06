LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY STACKPOINTER IS
	PORT(
		clk : IN std_logic;
		reset: IN std_logic;
		SP  : IN std_logic_vector(2 DOWNTO 0); -- SP[0] is the enable // SP[1] & SP[2] are selector for mux
        	SP_data  : INOUT std_logic_vector(31 DOWNTO 0)
	);
END ENTITY STACKPOINTER;

ARCHITECTURE Arch_STACKPOINTER OF STACKPOINTER IS
BEGIN
		PROCESS(clk,reset) IS
		BEGIN
			IF (reset = '1') THEN
				SP_data <= "00000000000011111111111111111111";
			END IF;
			IF falling_edge(clk) THEN  
				IF SP(0) = '1' THEN
					IF SP(1)='0' and SP(2)='0' THEN -- 00 decrement by 1 PUSH

						SP_data <= std_logic_vector( to_unsigned( to_integer(unsigned(SP_data)) - 1 , 32) );

					ELSIF SP(1)='1' and SP(2)='0' THEN -- 01 increment by 1 POP

						SP_data <= std_logic_vector( to_unsigned( to_integer(unsigned(SP_data)) + 1 , 32) );

					ELSIF SP(1)='0' and SP(2)='1' THEN -- 10 decrement by 2 PUSH

						SP_data <= std_logic_vector( to_unsigned( to_integer(unsigned(SP_data)) - 2 , 32) );

					ELSIF SP(1)='1' and SP(2)='1' THEN -- 11 increment by 2 POP

						SP_data <= std_logic_vector( to_unsigned( to_integer(unsigned(SP_data)) + 2 , 32) );

					END IF;
				ELSE
					SP_data <= SP_data;
				END IF;
			END IF;
		END PROCESS;
END Arch_STACKPOINTER;

