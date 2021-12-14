Library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;

ENTITY ALU IS
PORT
( Rsrc1,Rsrc2: IN std_logic_vector(15 DOWNTO 0);
ALU_out: OUT std_logic_vector(15 DOWNTO 0));
END ALU;


ARCHITECTURE archALU OF ALU IS




BEGIN

ALU_out<=std_logic_vector(unsigned(Rsrc1)+unsigned(Rsrc2)+1);


END archALU;