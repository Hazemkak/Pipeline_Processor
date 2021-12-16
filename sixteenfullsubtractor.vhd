Library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;

entity sixteenbitfullsubtractor is
    port(
        A, B: in std_logic_vector(15 downto 0);
        Bin: in std_logic;
        sub: out std_logic_vector(15 downto 0);
        Bout: out std_logic
    );
end sixteenbitfullsubtractor;

architecture data_sixteenbitfullsubtractor of sixteenbitfullsubtractor is
    component onebitfullsubtractor is
        port(
            A, B, Bin: in std_logic;
            sub, Bout: out std_logic
        );
    end component;

    signal temp: std_logic_vector(16 downto 0);

    begin
        temp(0) <= Bin;
        loop1: for i in 0 to 15 generate
            fx: onebitfullsubtractor port map(A(i), B(i), temp(i), sub(i), temp(i+1));
        end generate;
        Bout <= temp(16);
    end data_sixteenbitfullsubtractor;
