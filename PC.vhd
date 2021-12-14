
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY PC_reg IS
PORT(
d : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
en : IN STD_LOGIC; 
reset : IN STD_LOGIC; 
clk : IN STD_LOGIC;
q : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)); 
END PC_reg;
ARCHITECTURE PCarchReg OF PC_reg IS

BEGIN

 process(clk, reset)
   begin
    if (reset = '1') then 
         q <=(Others => '0');
    elsif (rising_edge (clk))  then
        if (en='1') then
            q <= d;  
        end if ;
        
       
      end if;
   end process;
END PCarchReg;