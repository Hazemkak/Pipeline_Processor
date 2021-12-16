Library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;
-- this code is not working yet, it needs restructuring of twobyone mux
entity flagsintegration is
    port(
        -----------input to flag register and output from ALU -----------
        ALUThreeflags: in std_logic_vector(2 downto 0); --input from ALU when ADD or SUB
        ALUTwoFlags: in std_logic_vector(2 downto 0); --input from ALU when AND or NOT
        setCarry: in  std_logic; --input from ID/EX buffer
        flagEn: in std_logic_vector(1 downto 0); --input from ID/EX buffer
        clk, rst: in std_logic;
        ----------------------------------------------------------------
        ---------input select to mux1-----------------------------------
        flagRes: in std_logic; --input from ID/EX buffer to mux1 select
        ----------------------------------------------------------------
        ---------input select to mux2-----------------------------------
        flagRev: in std_logic --input from ID/EX buffer to mux2 select
        ----------------------------------------------------------------
    );
end flagsintegration;

architecture behav_flagsintegration of flagsintegration is
    component flagregisterV2 is
        port(
            ALUThreeFlags: in std_logic_vector(2 downto 0);
            ALUTwoFlags: in std_logic_vector(2 downto 0);
            setCarry: in std_logic;
            flagRev: in std_logic_vector(2 downto 0);
            flagSel: in std_logic_vector(1 downto 0);
            clk, rst: in std_logic;
            carryFlag, negativeFlag, zeroFlag: out std_logic
        );
    end component;

    component flagstoreregister is
        port(
            inputCarryFlag, inputNegativeFlag, inputZeroFlag: in std_logic;
            carryFlag, negativeFlag, zeroFlag: out std_logic;
            clk, rst: in std_logic
        );
    end component;

    component twobyonemux is
        port(
            in0, in1: in std_logic_vector(2 downto 0);
            sel: in std_logic;
            output: out std_logic_vector(2 downto 0) 
        );
    end component;

    signal FRcarryFlag, FRnegativeFlag, FRzeroFlag:  std_logic;
    signal FSRcarryFlag, FSRnegativeFlag, FSRzeroFlag:  std_logic;
    signal mux1Output, mux2Output: std_logic_vector(2 downto 0);
    signal temp1, temp2: std_logic_vector(2 downto 0);
    begin
        temp1 <= FRzeroFlag & FRnegativeFlag & FRcarryFlag;
        temp2 <= FSRzeroFlag & FSRnegativeFlag & FSRcarryFlag;
        FR: flagregisterV2 port map(ALUThreeFlags, ALUTwoFlags, setCarry, mux2Output, flagEN, clk, rst, FRcarryFlag, FRnegativeFlag, FRzeroFlag);
        mux1: twobyonemux port map(temp1, temp2, flagRes, mux1Output);
        FSR: flagstoreregister port map(mux1Output(0), mux1Output(1), mux1Output(2), FSRcarryFlag, FSRnegativeFlag, FSRzeroFlag, clk, rst);
        mux2: twobyonemux port map(temp1, temp2, FlagRev, mux2Output);
    end behav_flagsintegration;
