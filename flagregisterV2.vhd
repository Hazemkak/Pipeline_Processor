Library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;

entity flagregisterV2 is
    port(
        ALUThreeFlags: in std_logic_vector(2 downto 0);
        ALUTwoFlags: in std_logic_vector(2 downto 0);
        setCarry: in std_logic;
        flagRev: in std_logic_vector(2 downto 0);
        flagSel: in std_logic_vector(1 downto 0);
        clk, rst: in std_logic;
        carryFlag, negativeFlag, zeroFlag: out std_logic
    );
end flagregisterV2;

architecture data_flagregisterV2 of flagregisterV2 is
    begin
        process(clk, rst)
        begin
            if (rst = '1') then
                carryFlag <= '0';
                negativeFlag <= '0';
                zeroFlag <= '0';
            elsif (clk'event and clk = '1') then
                if (flagSel = "00") then
                    carryFlag <= flagRev(0);
                    negativeFlag <= flagRev(1);
                    zeroFlag <= flagRev(2);
                elsif (flagSel = "01") then
                    carryFlag <= setCarry;
                elsif (flagSel <= "10") then
                    negativeFlag <= ALUTwoFlags(1);
                    zeroFlag <= ALUTwoFlags(2);
                else 
                    carryFlag <= ALUThreeFlags(0);
                    negativeFlag <= ALUThreeFlags(1);
                    zeroFlag <= ALUThreeFlags(2);
                end if;
            end if;
        end process;
    end data_flagregisterV2;
