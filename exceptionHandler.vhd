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
        isInt : IN std_logic;
        SP_select : IN std_logic_vector(2 DOWNTO 0);-- SP(0) is the enable of SP 
        aluData : IN std_logic_vector(31 DOWNTO 0);
        SP_data  : IN std_logic_vector(31 DOWNTO 0);
        memOut : in std_logic_vector(31 DOWNTO 0);
        enableInReg : OUT std_logic;--TODO:
		memoAddress : OUT std_logic_vector(31 DOWNTO 0)
        
        );
    
END ENTITY ExceptionHandler;

ARCHITECTURE ExceptionHandlerArc OF ExceptionHandler IS
signal q : std_logic_vector(31 DOWNTO 0);
BEGIN
    process(clk,rst)
    begin
    if (rst = '1') then 
      q <=(Others => '0');
     elsif (falling_edge (clk))  then
         q <=memOut ;  
        end if;
     end process;

        memoAddress <= "00000000000000000000000000000001" WHEN rst='1' 
            ELSE "00000000000000000000000000000011" WHEN (SP_select(0) = '1' AND SP_select(1)='1' AND SP_select(2)='0' AND SP_data > x"000fffff") --inc 1
            ELSE "00000000000000000000000000000011" WHEN (SP_select(0) = '1' AND SP_select(1)='1' AND SP_select(2)='1' AND SP_data > x"000fffff") --inc 2
            ELSE SP_data WHEN SP_select(0) = '1' and (isInt='0')
            else x"00000007" when (isInt='1'and clk='1')
            else std_logic_vector(unsigned(aluData)+unsigned(q)+1) when (isInt='1'and clk='0')
            ELSE "00000000000000000000000000000101" WHEN ((MR = '1' or MW16 = '1' or MW32 = '1') AND aluData > x"0000ff00") 
            ELSE aluData WHEN (MR = '1' or MW16 = '1' or MW32 = '1')
            ELSE "00000000000000000000000000001111";--put anything what will be read won't be used
        
        enableInReg <= '0' WHEN rst='1'
            ELSE '1' WHEN (SP_select(0) = '1' AND SP_select(1)='1' AND SP_select(2)='0' AND SP_data > x"000fffff") 
            ELSE '1' WHEN (SP_select(0) = '1' AND SP_select(1)='1' AND SP_select(2)='1' AND SP_data > x"000fffff")
            ELSE '0' WHEN SP_select(0) = '1' 
            ELSE '1' WHEN ((MR = '1' or MW16 = '1' or MW32 = '1') AND aluData > x"0000ff00") 
            ELSE '0' WHEN (MR = '1' or MW16 = '1' or MW32 = '1')
            ELSE '0';

END ExceptionHandlerArc;