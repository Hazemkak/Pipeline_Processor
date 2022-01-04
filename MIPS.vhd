

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY MIPS IS
	PORT(
		clk : IN std_logic;
    reset : IN STD_LOGIC;
		datain  : IN  std_logic_vector(15 DOWNTO 0);
		dataout : OUT std_logic_vector(15 DOWNTO 0));
END ENTITY MIPS;



ARCHITECTURE ArchMIPS OF MIPS IS

component PC_reg IS
PORT(
d : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
en : IN STD_LOGIC; 
reset : IN STD_LOGIC; 
clk : IN STD_LOGIC;
q : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)); 
END component;

component InstractionMem IS
	PORT(
		address : IN  std_logic_vector(31 DOWNTO 0);
		dataout : OUT std_logic_vector(31 DOWNTO 0));
END component InstractionMem;

component IFID IS
PORT(
d : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
en : IN STD_LOGIC; 
reset : IN STD_LOGIC; 
clk : IN STD_LOGIC;
q : OUT STD_LOGIC_VECTOR(63 DOWNTO 0)); 
END component;


component IDEX IS
PORT(
d : IN STD_LOGIC_VECTOR(114 DOWNTO 0);
en : IN STD_LOGIC; 
reset : IN STD_LOGIC; 
clk : IN STD_LOGIC;
q : OUT STD_LOGIC_VECTOR(114 DOWNTO 0)); 
END component;


component registerfile IS
PORT(
reset : IN STD_LOGIC; 
clk : IN STD_LOGIC;
src1 : in STD_LOGIC_VECTOR(2 DOWNTO 0); 
src2 : in STD_LOGIC_VECTOR(2 DOWNTO 0); 
Write_en :  IN STD_LOGIC;
WriteDst : in STD_LOGIC_VECTOR(2 DOWNTO 0); 
WriteData: in STD_LOGIC_VECTOR(15 DOWNTO 0);
Rsrc1 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0); 
Rsrc2 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)); 
END component;


component reg16bit IS
PORT(
d : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
en : IN STD_LOGIC; 
reset : IN STD_LOGIC; 
clk : IN STD_LOGIC;
q : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)); 
END component;

component EXMEM IS
PORT(
d : IN STD_LOGIC_VECTOR(79 DOWNTO 0);
en : IN STD_LOGIC; 
reset : IN STD_LOGIC; 
clk : IN STD_LOGIC;
q : OUT STD_LOGIC_VECTOR(79 DOWNTO 0)); 
END component;

component MEMWB IS
PORT(
d : IN STD_LOGIC_VECTOR(60 DOWNTO 0);
en : IN STD_LOGIC; 
reset : IN STD_LOGIC; 
clk : IN STD_LOGIC;
q : OUT STD_LOGIC_VECTOR(60 DOWNTO 0)); 
END component;

component ALU IS
PORT
( Rsrc1,Rsrc2: IN std_logic_vector(15 DOWNTO 0);
ALU_out: OUT std_logic_vector(15 DOWNTO 0));
END component;

component control is 
PORT
( op_code: IN std_logic_vector(4 DOWNTO 0);
sel : in std_logic;
control_signals : OUT std_logic_vector(25 DOWNTO 0)
);
END component;


component DataMEM IS
	PORT(
		clk : IN std_logic;
		MW32  : IN std_logic;
    MW16  : IN std_logic;
    MR : in std_logic;
		address : IN  std_logic_vector(31 DOWNTO 0);
		data_16bits : IN  std_logic_vector(15 DOWNTO 0);
		data_32bits : IN  std_logic_vector(31 DOWNTO 0);

		dataout : OUT std_logic_vector(31 DOWNTO 0));
END component ;


component STACKPOINTER IS
	PORT(
		clk : IN std_logic;
		reset: IN std_logic;
		SP  : IN std_logic_vector(2 DOWNTO 0); -- SP[0] is the enable // SP[1] & SP[2] are selector for mux
  	SP_data  : INOUT std_logic_vector(31 DOWNTO 0)
	);
END component ;

component writeback is
    port(
        InEnable,WBSel: in std_logic;
        InPort,AluData,MemData: in std_logic_vector(15 downto 0);
        WBOut: out std_logic_vector(15 downto 0) 
    );
end component;


component executestage is
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
        flagRev: in std_logic; --input from ID/EX buffer to mux2 select
        ------------------------------------------------------------------

        
        ----input from ID/EX buffer----------------------------------
        jmpSel: in std_logic_vector(2 downto 0);
        -------------------------------------------------------------

        ----output from execute stage-------------------------------------
        jmpOrNoJump: out std_logic
        ------------------------------------------------------------------
    );
end component;

component MUX_4_1_32bit is
  port(
      in0, in1, in2, in3: in std_logic_vector(31 downto 0);
      sel: in std_logic_vector(1 downto 0);
      output: out std_logic_vector(31 downto 0) 
  );
end component;

component Hazard_Unit is
  port(
    regSrc1, regSrc2: in std_logic_vector(2 downto 0);
    regDest_IDEX : in std_logic_vector(2 downto 0);
    WB_IDEX, MR_IDEX,HZEN: in std_logic;

    hz: out std_logic
);
end component;




signal PC_en , IFID_en ,IDEX_en,EXMEM_en,MEMWB_en, write_en: std_logic;
signal write_address : std_logic_vector(2 downto 0);
signal PC : std_logic_vector (31 downto 0);
signal newPC ,Next_PC: std_logic_vector (31 downto 0);
signal instraction :std_logic_vector (31 downto 0);
signal IFID_in,IFID_out  : std_logic_vector (63 downto 0);
signal  IDEX_in ,IDEX_out: std_logic_vector (114 downto 0);
signal  EXMEM_in ,EXMEM_out: std_logic_vector (79 downto 0);
signal  MEMWB_in ,MEMWB_out: std_logic_vector (60 downto 0);
signal cin : std_logic_vector(31 downto 0);
signal Rsrc1,Rsrc2,writedata,alu_out :  STD_LOGIC_VECTOR(15 DOWNTO 0); 

signal controls : STD_LOGIC_VECTOR(25 DOWNTO 0); 
signal address :  STD_LOGIC_VECTOR(31 DOWNTO 0);
signal sp_data :  STD_LOGIC_VECTOR(31 DOWNTO 0);
signal mem_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal AluSel : STD_LOGIC_VECTOR(1 DOWNTO 0); -- input to EX stage 

signal load_use : std_logic;

signal jmp_Address: STD_LOGIC_VECTOR(31 DOWNTO 0);
signal Jump,exception : std_logic;
signal PC_sel : STD_LOGIC_VECTOR(1 DOWNTO 0); 
signal IFID_rst, IDEX_rst : std_logic;
signal InputPort :STD_LOGIC_VECTOR(15 DOWNTO 0);


begin



cin<="0000000000000000000000000000000"&instraction(1);
Next_PC<=std_logic_vector(unsigned(PC)+1+unsigned(cin));

jmp_Address<=x"0000"&alu_out;
Pc_sel<= (exception or EXMEM_out(4))&Jump;
PC_MUX : MUX_4_1_32bit port map (Next_PC,jmp_Address,mem_out,mem_out,Pc_sel,newPC);

-----------------------------------------------------------------------------------------------------------------------------------
-- Fetch stage 


PC_en<= '0'  WHEN (instraction( 15 downto 11)="00001" or load_use='1')
	else '1';
ProgramCounter : PC_reg port map(newPC,PC_en,reset,clk,PC);
insrcMem : InstractionMem port map(PC,instraction);

----------------------------
 -- IF/ID buffer

IFID_en<= (not load_use);
IFID_rst<= reset or Jump or Pc_sel(1);
IFID_in<= newPC&instraction;
IFID_buff : IFID port map(IFID_in,IFID_en,IFID_rst,clk,IFID_out);

-----------------------------------------------------------------------------------------------------------------------------------
-- Decode stage


Hz_detection_unit :Hazard_Unit port map(IFID_out(7 downto 5),IFID_out(4 downto 2),IDEX_out(66 downto 64),IDEX_out(21),IDEX_out(15),IFID_out(0),load_use);


controlUnit : control port map (IFID_out( 15 downto 11),load_use ,controls ); -- opcode (input) , controls (output)
regFile :registerfile port map(reset,clk,IFID_out(7 downto 5),IFID_out(4 downto 2),write_en,write_address,writedata,Rsrc1,Rsrc2);

----------------------------
 -- ID/EX buffer

IDEX_en<='1';
IDEX_rst<=reset or Pc_sel(1); 
IDEX_in<=IFID_out(63 downto 32)&IFID_out(31 downto 16)&IFID_out(10 downto 2)&Rsrc1&Rsrc2&controls;
IDEX_buff : IDEX port map(IDEX_in,IDEX_en,IDEX_rst,clk,IDEX_out);

-----------------------------------------------------------------------------------------------------------------------------------
-- Ex stage

--Jump<= '0'; -- if the branch is taken set it to '1'


AluSel<=IDEX_out(18)&IDEX_out(4);
ex: executestage port map (EXMEM_out(28 downto 13),writedata,IDEX_out(57 downto 42),IDEX_out(82 downto 67),AluSel ,IDEX_out(41 downto 26),IDEX_out(3 downto 1),alu_out,IDEX_out(63 downto 61),IDEX_out(60 downto 58),EXMEM_out(47 downto 45),MEMWB_out(60 downto 58),EXMEM_out(8),MEMWB_out(5),IDEX_out(0), IDEX_out(7 downto 5),clk,reset,IDEX_out(9),IDEX_out(8),IDEX_out(12 downto 10),Jump);

Out_Reg: reg16bit port map(alu_out,IDEX_out(19),reset,clk,dataout); --IDEX_out maybe change to EXMEM_buff
----------------------------
-- EX/MEM buffer

EXMEM_en<='1';
InputPort<= datain  WHEN (IDEX_out(20)='1')
	else alu_out;
EXMEM_in<=IDEX_out(114 downto 83) &IDEX_out(66 downto 64)&IDEX_out(57 downto 42)&InputPort&IDEX_out(25 downto 13);
EXMEM_buff : EXMEM port map(EXMEM_in,EXMEM_en,reset,clk,EXMEM_out);

-----------------------------------------------------------------------------------------------------------------------------------
--Mem stage 

exception<='0'; -- if there is an exception set it to '1'




sp : STACKPOINTER port map (clk,reset,EXMEM_out(12 downto 10),sp_data) ;

-- (Temp for testing ) it should change with mux later 
address<=sp_data when EXMEM_out(10)='1' -- stack
  else x"00000001" when EXMEM_out(3)='1'-- reset
  else x"0000"&EXMEM_out(28 downto 13); -- address from alu
memo :DataMEM port map (clk,EXMEM_out(0),EXMEM_out(1),EXMEM_out(2),address,EXMEM_out(44 downto 29),EXMEM_out(79 downto 48),mem_out); --

----------------------------
-- MEM/WB buffer

MEMWB_en<='1';
MEMWB_in<=EXMEM_out(47 downto 45)&mem_out&EXMEM_out(28 downto 13)&EXMEM_out(12 downto 3);
MEMWB_buff : MEMWB port map(MEMWB_in,MEMWB_en,reset,clk,MEMWB_out); -- 

-----------------------------------------------------------------------------------------------------------------------------------






-- WB stage 
-- here i considerd the in port in the writeback which is false and will be changed 
write_Back: writeback port map (MEMWB_out(4),MEMWB_out(6),datain,MEMWB_out(25 downto 10),MEMWB_out(57 downto 42),writedata);
-- alu from 10 to 25 from mem 26+16=42 to 57 4 6 datain
write_address<=MEMWB_out(60 downto 58); 
write_en<=MEMWB_out(5) and (not exception);



END ArchMIPS;