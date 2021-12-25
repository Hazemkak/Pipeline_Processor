Library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;

entity Hazard_Unit is
    port(
        regSrc1, regSrc2: in std_logic_vector(2 downto 0);
        regDest_IDEX : in std_logic_vector(2 downto 0);
        WB_IDEX, MR_IDEX,HZEN: in std_logic;

        hz: out std_logic
    );
end Hazard_Unit;


architecture archHazard_Unit of Hazard_Unit is
    begin

        hz <= '0' when HZEN = '0' or WB_IDEX='0' or MR_IDEX= '0'
        else '1' when regSrc1 = regDest_IDEX or regSrc2 =  regDest_IDEX
        else '0';
    end archHazard_Unit;