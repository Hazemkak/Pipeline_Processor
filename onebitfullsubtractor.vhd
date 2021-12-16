Library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;

entity onebitfullsubtractor is
    port(
        A, B, Bin: in std_logic;
        sub, Bout: out std_logic
    );

end onebitfullsubtractor;

architecture data_onebitfullsubtractor of onebitfullsubtractor is
    begin
        sub <= ((A xor B) xor Bin);
        Bout <= (((not (A xor B)) and Bin) or ((not A) and B));
    end data_onebitfullsubtractor;
