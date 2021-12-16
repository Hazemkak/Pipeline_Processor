Library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;

entity tristatebuffer is
    port(
        input: in std_logic;
        output: out std_logic;
        enable: in std_logic
    );
end tristatebuffer;

architecture data_tristatebuffer of tristatebuffer is
    begin
        output <= 'Z' when enable = '0'
        else input;
    end data_tristatebuffer;
