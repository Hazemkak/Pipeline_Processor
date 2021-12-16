Library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;

entity ALU is
    port(
        firstOperand, secondOperand: in std_logic_vector(15 downto 0);
        result: out std_logic_vector(15 downto 0);
        carryFlag, zeroFlag, negativeFlag: out std_logic;
        sel: in std_logic_vector(2 downto 0);
        carryFlagEnable, zeroFlagEnable, negativeFlagEnable: out std_logic
    );
end ALU;

architecture data_ALU of ALU is
    component sixteenbitfulladder is
        port(
        A, B: in std_logic_vector(15 downto 0);
        Cin: in std_logic;
        sum: out std_logic_vector(15 downto 0);
        Cout: out std_logic
    );
    end component;

    component sixteenbitfullsubtractor is
        port(
        A, B: in std_logic_vector(15 downto 0);
        Bin: in std_logic;
        sub: out std_logic_vector(15 downto 0);
        Bout: out std_logic
    );
    end component;

    signal addResult, incResult, subResult: std_logic_vector(15 downto 0);
    signal addCarry, incCarry, subBorrow: std_logic;

    begin
        add: sixteenbitfulladder port map(firstOperand, secondOperand, '0', addResult, addCarry);
        sub: sixteenbitfullsubtractor port map(firstOperand, secondOperand, '0', subResult, subBorrow);
        inc: sixteenbitfulladder port map(firstOperand, "0000000000000001", '0', incResult, incCarry);

        result <= firstOperand when sel = "000"
        else firstOperand when sel = "001"
        else (not firstOperand) when sel = "010"
        else  incResult when sel = "011"
        else addResult when sel = "100"
        else subResult when sel = "101"
        else (firstOperand and secondOperand) when sel = "110"
        else firstOperand;

        ---------Carry Flag----------------------------------------------
        carryFlag <= '0' when sel = "000"
        else '1' when sel = "001"
        else '0' when sel = "010"
        else incCarry when sel = "011"
        else addCarry when sel = "100"
        else subBorrow when sel = "101"
        else '0' when sel = "110"
        else '0';
        
        carryFlagEnable <= '0' when sel = "000"
        else '1' when sel = "001"
        else '0' when sel = "010"
        else '0' when sel = "011"
        else '1' when sel = "100"
        else '1' when sel = "101"
        else '0' when sel = "110"
        else '0';
        -----------------------------------------------------------------

        ----------Negative Flag------------------------------------------
        negativeFlag <= '0' when sel = "000"
        else '0' when sel = "001"
        else (not firstOperand(15)) when sel = "010"
        else incResult(15) when sel = "011"
        else addResult(15) when sel = "100"
        else subResult(15) when sel = "101"
        else (firstOperand(15) and secondOperand(15)) when sel = "110"
        else '0';

        negativeFlagEnable <= '0' when sel = "000"
        else '0' when sel = "001"
        else '1' when sel = "010"
        else '1' when sel = "011"
        else '1' when sel = "100"
        else '1' when sel = "101"
        else '1' when sel = "110"
        else '0';
        -----------------------------------------------------------------

        ---------Zero Flag-----------------------------------------------
        zeroFlag <= '0' when sel = "000"
        else '0' when sel = "001"
        else '1' when (not firstOperand) = "0000000000000000" and sel = "010"
        else '1' when incResult = "0000000000000000" and sel = "011"
        else '1' when addResult = "0000000000000000" and sel = "100"
        else '1' when subResult = "0000000000000000" and sel = "101"
        else '1' when (firstOperand and secondOperand) = "0000000000000000" and sel = "110"
        else '0';

        zeroFlagEnable <= '0' when sel = "000"
        else '0' when sel = "001"
        else '1' when sel = "010"
        else '1' when sel = "011"
        else '1' when sel = "100"
        else '1' when sel = "101"
        else '1' when sel = "110"
        else '0';
        -----------------------------------------------------------------
        end data_ALU;

