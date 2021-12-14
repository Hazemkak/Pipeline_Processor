
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY registerfile IS
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
END registerfile;





ARCHITECTURE Archregisterfile OF registerfile IS
component reg16bit IS
PORT(
d : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
en : IN STD_LOGIC; 
reset : IN STD_LOGIC; 
clk : IN STD_LOGIC;
q : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)); 
end component reg16bit;

component tri_state_buffer is
  Port ( 
         Bin  : in  STD_LOGIC_VECTOR (15 downto 0);
         en  : in  STD_LOGIC;
         Bout : out STD_LOGIC_VECTOR (15 downto 0));
end component;
component decoder3_8 is 
PORT
( Sel: IN std_logic_vector(2 DOWNTO 0);
Dout : OUT std_logic_vector(7 DOWNTO 0)
);
END component;



signal dst_reg_en,src1_reg_en ,src2_reg_en: std_logic_vector(7 downto 0);
signal qreg0,qreg1,qreg2,qreg3,qreg4,qreg5,qreg6,qreg7: std_logic_vector (15 downto 0);
signal wb_dst0,wb_dst1,wb_dst2,wb_dst3,wb_dst4,wb_dst5,wb_dst6,wb_dst7 : std_logic;

BEGIN

Dst_decoder : decoder3_8 port map (WriteDst,dst_reg_en);
src1_decoder : decoder3_8 port map (src1,src1_reg_en);
src2_decoder : decoder3_8 port map (src2,src2_reg_en);

wb_dst0<= dst_reg_en(0) and Write_en;
wb_dst1<= dst_reg_en(1) and Write_en;
wb_dst2<= dst_reg_en(2) and Write_en;
wb_dst3<= dst_reg_en(3) and Write_en;
wb_dst4<= dst_reg_en(4) and Write_en;
wb_dst5<= dst_reg_en(5) and Write_en;
wb_dst6<= dst_reg_en(6) and Write_en;
wb_dst7<= dst_reg_en(7) and Write_en;

r0 : reg16bit port map(WriteData,wb_dst0, reset,clk,qreg0);
r1 : reg16bit port map(WriteData,wb_dst1, reset,clk,qreg1);
r2 : reg16bit port map(WriteData,wb_dst2, reset,clk,qreg2);
r3 : reg16bit port map(WriteData,wb_dst3, reset,clk,qreg3);
r4 : reg16bit port map(WriteData,wb_dst4, reset,clk,qreg4);
r5 : reg16bit port map(WriteData,wb_dst5, reset,clk,qreg5);
r6 : reg16bit port map(WriteData,wb_dst6, reset,clk,qreg6);
r7 : reg16bit port map(WriteData,wb_dst7, reset,clk,qreg7);



t0_1 : tri_state_buffer port map (qreg0,src1_reg_en(0),Rsrc1);
t1_1 : tri_state_buffer port map (qreg1,src1_reg_en(1),Rsrc1);
t2_1 : tri_state_buffer port map (qreg2,src1_reg_en(2),Rsrc1);
t3_1 : tri_state_buffer port map (qreg3,src1_reg_en(3),Rsrc1);
t4_1 : tri_state_buffer port map (qreg4,src1_reg_en(4),Rsrc1);
t5_1 : tri_state_buffer port map (qreg5,src1_reg_en(5),Rsrc1);
t6_1 : tri_state_buffer port map (qreg6,src1_reg_en(6),Rsrc1);
t7_1 : tri_state_buffer port map (qreg7,src1_reg_en(7),Rsrc1);

t0_2 : tri_state_buffer port map (qreg0,src2_reg_en(0),Rsrc2);
t1_2 : tri_state_buffer port map (qreg1,src2_reg_en(1),Rsrc2);
t2_2 : tri_state_buffer port map (qreg2,src2_reg_en(2),Rsrc2);
t3_2 : tri_state_buffer port map (qreg3,src2_reg_en(3),Rsrc2);
t4_2 : tri_state_buffer port map (qreg4,src2_reg_en(4),Rsrc2);
t5_2 : tri_state_buffer port map (qreg5,src2_reg_en(5),Rsrc2);
t6_2 : tri_state_buffer port map (qreg6,src2_reg_en(6),Rsrc2);
t7_2 : tri_state_buffer port map (qreg7,src2_reg_en(7),Rsrc2);


END Archregisterfile;