Library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;

entity flagregister is
    port(
        -------ALU Flags---------------------
        carryFlagALU: in std_logic;
        zeroFlagALU: in std_logic;
        negativeFlagAlU: in std_logic;
        -------------------------------------
        -------Reserved Flags----------------
        carryFlagRev: in std_logic;
        zeroFlagRev: in std_logic;
        negativeFlagRev: in std_logic;
        -------------------------------------
        flagEN: in std_logic;
        clk, rst: in std_logic;
        carryFlag, zeroFlag, negativeFlag: out std_logic
    );
end flagregister;

architecture behav_flagregister of flagregister is
    begin
        process(clk, rst)
        begin
            if (rst = '1') then
                carryFlag <= '0';
                negativeFlag <= '0';
                zeroFlag <= '0';
            elsif (clk'event and clk = '1') then
                if (flagEN = '1') then
                    carryFlag <= carryFlagALU;
                    zeroFlag <= zeroFlagALU;
                    negativeFlag <= negativeFlagALU;
                elsif (flagEN = '0') then
                    carryFlag <= carryFlagRev;
                    zeroFlag <= zeroFlagRev;
                    negativeFlag <= negativeFlagRev;
                end if;
            end if;
        end process;
    end behav_flagregister;
