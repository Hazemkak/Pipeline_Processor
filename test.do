quit -sim
vsim -gui work.mips
 
mem load -i C:/Users/user/Desktop/Pipeline_Processor/bin.mem /mips/insrcMem/ram
mem load -i C:/Users/user/Desktop/Pipeline_Processor/data.mem /mips/memo/ram_arr


add wave -position insertpoint sim:/mips/*


force -freeze sim:/mips/clk 0 0, 1 {50 ps} -r 100
force -freeze sim:/mips/reset 1 0

add wave -position insertpoint  \
sim:/mips/ex/FI/outputZF \
sim:/mips/ex/FI/outputNF \
sim:/mips/ex/FI/outputCF

run 50ps
force -freeze sim:/mips/reset 0 0

