Library ieee;
use ieee.std_logic_1164.all;

entity decoder3_8 is 
PORT
( Sel: IN std_logic_vector(2 DOWNTO 0);
Dout : OUT std_logic_vector(7 DOWNTO 0)
);
END decoder3_8;

architecture archDecoder of decoder3_8 is
    begin
  
    with Sel select
        Dout <= 
            "00000001" when "000",
            "00000010" when "001",
            "00000100" when "010",
            "00001000" when "011",
            "00010000" when "100",
            "00100000" when "101",
            "01000000" when "110",
            "10000000" when "111",
            "00000000" when others;
            
   
  
end archDecoder ;