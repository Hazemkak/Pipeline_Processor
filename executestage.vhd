Library ieee;
use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;

entity executestage is
    port(
        -------forwarding hazard data and inputs to mux2 and mux3----------
        aluData: in std_logic_vector(15 downto 0); --from EX/MEM buffer
        memData: in std_logic_vector(15 downto 0); --from MEM/WB buffer
        -------------------------------------------------------------------

        --------------inputs to mux1---------------------------------------
        src1Data, imValue: in std_logic_vector(15 downto 0); --from ID/EX buffer
        aluSel: in std_logic_vector(1 downto 0); --from ID/EX buffer
        --this mux will get as input imIndex from adding 6 to imValue
        -------------------------------------------------------------------
        
        -------------inputs to mux2----------------------------------------
        src2Data: in std_logic_vector(15 downto 0);--from ID/EX buffer
        --this mux will get 2B from forwarding unit as input select
        -------------------------------------------------------------------

        -----------inputs to ALU-------------------------------------------
        operationSel: in std_logic_vector(2 downto 0); --from ID/EX buffer
        --this ALU will get output of mux2 and mux3 as input operands
        result: out std_logic_vector(15 downto 0);
        -------------------------------------------------------------------

        ---------------inputs to forwarding unit---------------------------
        src1RegNum, src2RegNum: in std_logic_vector(2 downto 0); --from ID/EX buffer
        regDest_EX: in std_logic_vector(2 downto 0); --from EX/MEM buffer
        regDest_MEM: in std_logic_vector(2 downto 0); --from MEM/WB buffer
        WB_EXMEM: in std_logic; --from EX/MEM buffer
        WB_MEMWB: in std_logic; -- from MEM/WB buffer
        HZEN: in std_logic; --from ID/EX buffer
        ------------------------------------------------------------------

        ---------------inputs to flagsintegration unit--------------------
        -- setCarry: in  std_logic; --input from ID/EX buffer
        flagEn: in std_logic_vector(2 downto 0); --input from ID/EX buffer
        clk, rst: in std_logic;
        flagRes: in std_logic; --input from ID/EX buffer to mux1 select
        flagRev: in std_logic --input from ID/EX buffer to mux2 select
        ------------------------------------------------------------------
    );
end executestage;

architecture data_executestage of executestage is
    component sixteenbitfulladder is
        port(
            A, B: in std_logic_vector(15 downto 0);
            Cin: in std_logic;
            sum: out std_logic_vector(15 downto 0);
            Cout: out std_logic
        );
    end component;

    component forwardingunit is
        port(
            regSrc1, regSrc2: in std_logic_vector(2 downto 0);
            regDest_EX, regDest_MEM: in std_logic_vector(2 downto 0);
            WB_EXMEM, WB_MEMWB, HZEN: in std_logic;
            oneB, twoB: out std_logic_vector(1 downto 0)
        );
    end component;

    component fourbyonemux is
        port(
            in0, in1, in2, in3: in std_logic_vector(15 downto 0);
            sel: in std_logic_vector(1 downto 0);
            output: out std_logic_vector(15 downto 0) 
        );
    end component;

    component ALU is
        port(
            firstOperand, secondOperand: in std_logic_vector(15 downto 0);
            result: out std_logic_vector(15 downto 0);
            carryFlag, zeroFlag, negativeFlag: out std_logic;
            sel: in std_logic_vector(2 downto 0);
            carryFlagEnable, zeroFlagEnable, negativeFlagEnable: out std_logic
        );
    end component;

    component tristatebuffer is
        port(
            input: in std_logic;
            output: out std_logic;
            enable: in std_logic
        );
    end component;

    component flagsintegration is
        port(
            -----------input to flag register and output from ALU -----------
            ALUThreeflags: in std_logic_vector(2 downto 0); --input from ALU when ADD or SUB
            ALUTwoFlags: in std_logic_vector(2 downto 0); --input from ALU when AND or NOT
            setCarry: in  std_logic; --input from ALU "1 when setCarry operation zero otherwise"
            flagEn: in std_logic_vector(2 downto 0); --input from ID/EX buffer
            clk, rst: in std_logic;
            ----------------------------------------------------------------

            ---------input select to mux1-----------------------------------
            flagRes: in std_logic; --input from ID/EX buffer to mux1 select
            ----------------------------------------------------------------

            ---------input select to mux2-----------------------------------
            flagRev: in std_logic --input from ID/EX buffer to mux2 select
            ----------------------------------------------------------------
        );
        end component;

    signal imIndex: std_logic_vector(15 downto 0); --output of sixteenbitfulladder and input to mux1
    signal imIndexCarry: std_logic; --output carry of sixteenbitfull adder 
    signal twoB, oneB: std_logic_vector(1 downto 0); --output of forwardingunit and select of mux2 and mux3 respectively
    signal mux1Output: std_logic_vector(15 downto 0); --output of mux1 and input to mux3
    signal mux2Output: std_logic_vector(15 downto 0); --output of mux2 and input to ALU
    signal mux3Output: std_logic_vector(15 downto 0); --output of mux3 and input to ALU
    signal zeroFlag, negativeFlag, carryFlag: std_logic; --output of ALU and input to flag register
    signal zeroFlagEnable, negativeFlagEnable, carryFlagEnable: std_logic; --output of ALU and input to tri-state buffer
    signal ALUThreeFlags, ALUTwoFlags: std_logic_vector(2 downto 0);

    begin
        adder: sixteenbitfulladder port map(imValue, "0000000000000110", '0', imIndex, imIndexCarry);
        mux1: fourbyonemux port map(src1Data, imValue, imIndex, "0000000000000000", aluSel, mux1Output);
        fu: forwardingunit port map(src1RegNum, src2RegNum, regDest_EX, regDest_MEM, WB_EXMEM, WB_MEMWB, HZEN, oneB, twoB);
        mux2: fourbyonemux port map(src2Data, aluData, memData, "0000000000000000", twoB, mux2Output);
        mux3: fourbyonemux port map(mux1Output, aluData, memData, "0000000000000000", oneB, mux3Output);
        alu1: ALU port map(mux3Output, mux2Output, result, carryFlag, zeroFlag, negativeFlag, operationSel, carryFlagEnable, zeroFlagEnable, negativeFlagEnable);
        ALUThreeFlags <= zeroFlag & negativeFlag & carryFlag;
        ALUTwoFlags <=  zeroFlag & negativeFlag & '0';
        FI: flagsintegration port map(ALUThreeFlags, ALUTwoFlags, carryFlag, flagEn, clk, rst, flagRes, flagRev);
    end data_executestage;
