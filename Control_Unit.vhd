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
  
    control_signals <= "00000000000000001000000000" when sel='1' 
           else "00000000000000001000000000" when op_code="00000"
           else "00000000000000001000000000" when op_code="00001"
           else "00000000000000001000100010" when op_code="00010"
           else "00001000000000001001000101" when op_code="00011"
           else "00001000000000001001100111" when op_code="00100"
           else "00000010000000001000000001" when op_code="00101"
           else "00001100000000001000000000" when op_code="00110"
           else "00001000000000001000000001" when op_code="00111"
           else "00001000000000001001101001" when op_code="01000"
           else "00001000000000001001101011" when op_code="01001"
           else "00001000000000001001001101" when op_code="01010"
           else "00001000000000001001111001" when op_code="01011"
           else "00100000000100001000000001" when op_code="01100"
           else "01111000001000001000000000" when op_code="01101"
           else "00001000000000001000010000" when op_code="01110"
           else "00011000001000001000011001" when op_code="01111"
           else "00000000000100001000011001" when op_code="10000"
           else "00000000000000111010000001" when op_code="10001"
           else "00000000000001011010100001" when op_code="10010"
           else "00000000000001111011000001" when op_code="10011"
           else "00000000000000011000000001" when op_code="10100"
           else "10100000100010001000000001" when op_code="10101"
           else "11100000101000001000000000" when op_code="10110"
           else "00000000111000000000000000" when op_code="11001"
           else "00000000000000001000000000";
            
   
  
end archcontrol ;