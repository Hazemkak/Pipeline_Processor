Library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;

entity forwardingunit is
    port(
        regSrc1, regSrc2: in std_logic_vector(2 downto 0);
        regDest_EX, regDest_MEM: in std_logic_vector(2 downto 0);
        WB_EXMEM, WB_MEMWB, HZEN: in std_logic;
        oneB, twoB: out std_logic_vector(1 downto 0)
    );
end forwardingunit;

architecture data_forwardingunit of forwardingunit is
    begin
        oneB <= "00" when HZEN = '0'
        else "00" when WB_EXMEM = '0' and WB_MEMWB = '0'
        else "00" when regSrc1 /= regDest_EX and regSrc1 /=  regDest_MEM
        else "01" when regSrc1 = regDest_EX and WB_EXMEM = '1'
        else "10" when regSrc1 = regDest_MEM and WB_MEMWB = '1'
        else "00";

        twoB <= "00" when HZEN = '0'
        else "00" when WB_EXMEM = '0' and WB_MEMWB = '0'
        else "00" when regSrc2 /= regDest_EX and regSrc2 /=  regDest_MEM
        else "01" when regSrc2 = regDest_EX and WB_EXMEM = '1'
        else "10" when regSrc2 = regDest_MEM and WB_MEMWB = '1'
        else "00";

        end data_forwardingunit;
