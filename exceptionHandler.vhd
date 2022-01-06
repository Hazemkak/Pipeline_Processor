LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY ExceptionHandler IS
	PORT(
		clk : IN std_logic;
		
		rst  : IN std_logic;
		MR : In std_logic;
        MW16 : In std_logic;
		MW32 : IN  std_logic;
        SP_select : IN std_logic_vector(2 DOWNTO 0);-- SP(0) is the enable of SP 
        aluData : IN std_logic_vector(31 DOWNTO 0);
        SP_data  : INOUT std_logic_vector(31 DOWNTO 0);

        enableInReg : OUT std_logic;--TODO:
		memoAddress : OUT std_logic_vector(31 DOWNTO 0));
END ENTITY ExceptionHandler;

ARCHITECTURE ExceptionHandlerArc OF ExceptionHandler IS
BEGIN

		PROCESS(clk) IS
		BEGIN
			IF rising_edge(clk) THEN  

                IF rst = '1' THEN

                    memoAddress <= "00000000000000000000000000000001";--32bit zeros
                    enableInReg <= '0';

				ELSIF SP_select(0) = '1' THEN -- check for empty stack pop

                    IF SP_select(1)='1' and SP_select(2)='0' THEN -- 01 increment by 1 POP16 , so check if SP_data is at last memo place

                        IF SP_data > "00000000000011111111111111111110" THEN
                            memoAddress <= "00000000000000000000000000000010";
                            enableInReg <= '1';
                        ELSE 
                            enableInReg <= '0';
                            memoAddress <= SP_data;
                        END IF;

                    ELSIF SP_select(1)='1' and SP_select(2)='1' THEN -- 11 increment by 2 POP32 , so check if SP_data is at  prev last memo place

                        IF SP_data > "00000000000011111111111111111101" THEN
                            memoAddress <= "00000000000000000000000000000011";
                            enableInReg <= '1';
                        ELSE 
                            enableInReg <= '0';
                            memoAddress <= SP_data;
                        END IF;
                        
                    END IF;
                    
                ELSE
                    
                    IF MR = '1' or MW16 = '1' or MW32 = '1' THEN
                        
                        IF aluData > "00000000000011111111111111111111" THEN
                            memoAddress <= "00000000000000000000000000000101";
                            enableInReg <= '1';
                        ELSE
                            memoAddress <= aluData;
                            enableInReg <= '0';
                        END IF;
                        
                    END IF;

				END IF;

			END IF;
		END PROCESS;

END ExceptionHandlerArc;