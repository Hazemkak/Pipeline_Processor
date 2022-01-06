Library ieee;
use ieee.std_logic_1164.all;

entity control is 
PORT
( op_code: IN std_logic_vector(4 DOWNTO 0);
  sel : in std_logic;
control_signals : OUT std_logic_vector(25 DOWNTO 0)
);
END control;

architecture archcontrol of control is
    begin
  
    control_signals <= "00000000000000000000000000" when sel='1' 
           else "00000000000000000000000000" when op_code="00000"
           else "00000000000000000000000000" when op_code="00001"
           else "00000000000000000000100010" when op_code="00010"
           else "00001000000000000001000101" when op_code="00011"
           else "00001000000000000001100111" when op_code="00100"
           else "00000010000000000000000001" when op_code="00101"
           else "00001100000000000000000000" when op_code="00110"
           else "00001000000000000000000001" when op_code="00111"
           else "00001000000000000001101001" when op_code="01000"
           else "00001000000000000001101011" when op_code="01001"
           else "00001000000000000001001101" when op_code="01010"
           else "00001000000000000001111001" when op_code="01011"
           else "00100000000100000000000001" when op_code="01100"
           else "01111000001000000000000000" when op_code="01101"
           else "00001000000000000000010000" when op_code="01110"
           else "00011000001000000000011001" when op_code="01111"
           else "00000000000100000000011001" when op_code="10000"
           else "00000000000000110010000001" when op_code="10001"
           else "00000000000001010010100001" when op_code="10010"
           else "00000000000001110011000001" when op_code="10011"
           else "00000000000000010000000001" when op_code="10100"
           else "10100000000010010000000001" when op_code="10101"
           else "11100000101000000000000000" when op_code="10110"
           else "10100001100010001000010000" when op_code="10111"
           else "11100000101000000100000000" when op_code="11000"
           else "00000000111000001000000000" when op_code="11001"
           else "00000000000000000000000000";
            
   
  
end archcontrol ;