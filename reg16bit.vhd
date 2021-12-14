
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY reg16bit IS
PORT(
d : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
en : IN STD_LOGIC; 
reset : IN STD_LOGIC; 
clk : IN STD_LOGIC;
q : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)); 
END reg16bit;
ARCHITECTURE Archreg16bit OF reg16bit IS

BEGIN

 process(clk, reset)
   begin
    if (reset = '1') then 
         q <=(Others => '0');
    elsif (falling_edge (clk))  then
        if (en='1') then
            q <= d;  
        end if ;
        
       
      end if;
   end process;
END Archreg16bit;