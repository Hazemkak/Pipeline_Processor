Library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;

entity sixteenbitfulladder is
    port(
        A, B: in std_logic_vector(15 downto 0);
        Cin: in std_logic;
        sum: out std_logic_vector(15 downto 0);
        Cout: out std_logic
    );
end sixteenbitfulladder;

architecture data_sixteenbitfulladder of sixteenbitfulladder is
    component onebitfulladder is
        port(
            A, B, Cin: in std_logic;
            sum, Cout: out std_logic
        );
    end component;

    signal temp: std_logic_vector(16 downto 0);

    begin
        temp(0) <= Cin;
        loop1: for i in 0 to 15 generate
            fx: onebitfulladder port map(A(i), B(i), temp(i), sum(i), temp(i+1));
        end generate;
        Cout <= temp(16);
    end data_sixteenbitfulladder;
