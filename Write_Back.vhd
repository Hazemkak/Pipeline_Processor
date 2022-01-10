Library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;

entity writeback is
    port(
        InEnable,WBSel: in std_logic;
        InPort,AluData,MemData: in std_logic_vector(15 downto 0);
        WBOut: out std_logic_vector(15 downto 0) 
    );
end writeback;

architecture Write_Back of writeback is
    begin
        WBOut <= InPort when InEnable = '1'
        else AluData when InEnable = '0' and WBSel = '0'
        else MemData when InEnable = '0' and WBSel = '1' ;
end Write_Back;
