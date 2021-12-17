Library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;

entity twobyonemux is
    port(
        in0, in1: in std_logic_vector(2 downto 0);
        sel: in std_logic;
        output: out std_logic_vector(2 downto 0) 
    );
end twobyonemux;

architecture data_twobyonemux of twobyonemux is
    begin
        output <= in0 when sel = '0'
        else in1 when sel = '1'
        else in0;
    end data_twobyonemux;
