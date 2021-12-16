Library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;

entity fourbyonemux is
    port(
        in0, in1, in2, in3: in std_logic_vector(15 downto 0);
        sel: in std_logic_vector(1 downto 0);
        output: out std_logic_vector(15 downto 0) 
    );
end fourbyonemux;

architecture data_fourbyonemux of fourbyonemux is
    begin
        output <= in0 when sel = "00"
        else in1 when sel = "01"
        else in2 when sel = "10"
        else in3 when sel = "11"
        else in3;
    end data_fourbyonemux;
