
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tri_state_buffer is
    Port ( 
           Bin  : in  STD_LOGIC_VECTOR (15 downto 0);
           en  : in  STD_LOGIC;
           Bout : out STD_LOGIC_VECTOR (15 downto 0));
end tri_state_buffer;

architecture archTriState  of tri_state_buffer is

begin
    
    Bout <= Bin when (en = '1') else  (Others => 'Z');

end archTriState;