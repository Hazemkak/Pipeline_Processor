Library ieee;
use ieee.std_logic_1164.all;

entity control is 
PORT
( op_code: IN std_logic_vector(4 DOWNTO 0);
control_signals : OUT std_logic_vector(23 DOWNTO 0)
);
END control;

architecture archcontrol of control is
    begin
  
    with op_code select
    control_signals <= 
            "000000000000000000000000" when "00000",
            "000000000000000000000001" when "00001",
            "000000000000000000100010" when "00010",
            "000010000000000000100100" when "00011",
            "000010000000000000100110" when "00100",
            "000000100000000000000000" when "00101",
            "000011000000000000000000" when "00110",
            "000010000000000000000000" when "00111",
            "000010000000000000101000" when "01000",
            "000010000000000000101010" when "01001",
            "000010000000000000101100" when "01010",
            "000010000000000000111000" when "01011",
            "001000000001000000000000" when "01100",
            "011110000010000000000000" when "01101",
            "000010000000000000010000" when "01110",
            "000110000010000000011000" when "01111",
            "000000000001000000011000" when "10000",
            "000000000000000000000000" when others;
            
   
  
end archcontrol ;