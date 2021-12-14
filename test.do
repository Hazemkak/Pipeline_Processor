vsim -gui work.mips
 
mem load -i E:/Modelsim/Project/bin.mem /mips/insrcMem/ram
add wave -position insertpoint  \
sim:/mips/clk \
sim:/mips/reset \
sim:/mips/newPC \
sim:/mips/PC \
sim:/mips/instraction \
sim:/mips/IFID_out \
sim:/mips/IFID_in \
sim:/mips/IDEX_in \
sim:/mips/IDEX_out \
sim:/mips/EXMEM_in \
sim:/mips/EXMEM_out \
sim:/mips/MEMWB_in \
sim:/mips/MEMWB_out \
sim:/mips/Rsrc1 \
sim:/mips/Rsrc2 \
sim:/mips/writedata \
sim:/mips/write_en \
sim:/mips/controls
force -freeze sim:/mips/clk 0 0, 1 {50 ps} -r 100
force -freeze sim:/mips/reset 1 0
run 50
force -freeze sim:/mips/reset 0 0

