Library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;

entity flagstoreregister is
    port(
        inputCarryFlag, inputNegativeFlag, inputZeroFlag: in std_logic;
        carryFlag, negativeFlag, zeroFlag: out std_logic;
        clk, rst: in std_logic
    );
end flagstoreregister;

architecture behav_flagstoreregister of flagstoreRegister is
    begin
        process(clk, rst)
        begin
            if (rst = '1') then
                carryFlag <= '0';
                negativeFlag <= '0';
                zeroFlag <= '0';
            elsif (clk'event and clk = '1') then
                carryFlag <= inputCarryFlag;
                negativeFlag <= inputNegativeFlag;
                zeroFlag <= inputZeroFlag;
            end if;
        end process;
    end behav_flagstoreregister;
