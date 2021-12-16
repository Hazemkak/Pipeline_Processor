Library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;

entity onebitfulladder is
    port(
        A, B, Cin: in std_logic;
        sum, Cout: out std_logic
    );

end onebitfulladder;

architecture data_onebitfulladder of onebitfulladder is
    begin
        sum <= ((A xor B) xor Cin);
        Cout <= (((A xor B) and Cin) or (A and B));
    end data_onebitfulladder;
