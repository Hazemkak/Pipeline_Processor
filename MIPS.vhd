

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
d : IN STD_LOGIC_VECTOR(112 DOWNTO 0);
en : IN STD_LOGIC; 
reset : IN STD_LOGIC; 
clk : IN STD_LOGIC;
q : OUT STD_LOGIC_VECTOR(112 DOWNTO 0)); 
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
control_signals : OUT std_logic_vector(23 DOWNTO 0)
);
END component;


signal PC_en , IFID_en ,IDEX_en,EXMEM_en,MEMWB_en, write_en: std_logic;
signal write_address : std_logic_vector(2 downto 0);
signal PC : std_logic_vector (31 downto 0);
signal newPC : std_logic_vector (31 downto 0);
signal instraction :std_logic_vector (31 downto 0);
signal IFID_in,IFID_out  : std_logic_vector (63 downto 0);
signal  IDEX_in ,IDEX_out: std_logic_vector (112 downto 0);
signal  EXMEM_in ,EXMEM_out: std_logic_vector (79 downto 0);
signal  MEMWB_in ,MEMWB_out: std_logic_vector (60 downto 0);
signal cin : std_logic_vector(31 downto 0);
signal Rsrc1,Rsrc2,writedata,alu_out :  STD_LOGIC_VECTOR(15 DOWNTO 0); 

signal controls : STD_LOGIC_VECTOR(23 DOWNTO 0); 



begin



cin<="0000000000000000000000000000000"&instraction(1);
newPC<=std_logic_vector(unsigned(PC)+1+unsigned(cin));

-----------------------------------------------------------------------------------------------------------------------------------
-- Fetch stage 

PC_en<= '0'  WHEN instraction( 15 downto 11)="00001"
	else '1';
ProgramCounter : PC_reg port map(newPC,PC_en,reset,clk,PC);
insrcMem : InstractionMem port map(PC,instraction);

----------------------------
 -- IF/ID buffer

IFID_en<='1';
IFID_in<= newPC&instraction;
IFID_buff : IFID port map(IFID_in,IFID_en,reset,clk,IFID_out);

-----------------------------------------------------------------------------------------------------------------------------------
-- Decode stage

controlUnit : control port map (IFID_out( 15 downto 11),controls ); -- opcode (input) , controls (output)
regFile :registerfile port map(reset,clk,IFID_out(7 downto 5),IFID_out(4 downto 2),write_en,write_address,writedata,Rsrc1,Rsrc2);

----------------------------
 -- ID/EX buffer

IDEX_en<='1';
IDEX_in<=IFID_out(63 downto 32)&IFID_out(31 downto 16)&IFID_out(10 downto 2)&Rsrc1&Rsrc2&controls;
IDEX_buff : IDEX port map(IDEX_in,IDEX_en,reset,clk,IDEX_out);

-----------------------------------------------------------------------------------------------------------------------------------
-- Ex stage

alu0 : ALU port map (IDEX_out(55 downto 40),IDEX_out(39 downto 24),alu_out);

----------------------------
-- EX/MEM buffer

EXMEM_en<='1';
EXMEM_in<=IDEX_out(112 downto 81) &IDEX_out(64 downto 62)&IDEX_out(39 downto 24)&alu_out&IDEX_out(23 downto 11);
EXMEM_buff : EXMEM port map(EXMEM_in,EXMEM_en,reset,clk,EXMEM_out);

-----------------------------------------------------------------------------------------------------------------------------------
--Mem stage 

----------------------------
-- MEM/WB buffer

MEMWB_en<='1';
MEMWB_in<=EXMEM_out(47 downto 45)&x"00000000"&EXMEM_out(28 downto 13)&EXMEM_out(12 downto 3);
MEMWB_buff : MEMWB port map(MEMWB_in,MEMWB_en,reset,clk,MEMWB_out);

-----------------------------------------------------------------------------------------------------------------------------------
-- WB stage 

writedata<=MEMWB_out(25 downto 10);
write_address<=MEMWB_out(60 downto 58);
write_en<=MEMWB_out(5);

END ArchMIPS;