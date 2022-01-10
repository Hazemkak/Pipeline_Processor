Library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;

entity jump is
    port(
        inputZF, inputNF, inputCF: in std_logic;
        jmpSel: in std_logic_vector(2 downto 0);
        jmpOrNoJump: out std_logic
    );
end jump;

architecture data_jump of jump is
    begin
        jmpOrNoJump <= '1' when jmpSel = "011" and inputZF = '1'
        else '1' when jmpSel = "101" and inputNF = '1'
        else '1' when jmpSel = "111" and inputCF = '1'
        else '1' when jmpSel = "001"
        else '0';
    end data_jump;