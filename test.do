quit -sim
vsim -gui work.mips
 
mem load -i E:/Pipeline_Processor/bin.mem /mips/insrcMem/ram
mem load -i E:/Pipeline_Processor/data.mem /mips/memo/ram_arr


add wave -position insertpoint sim:/mips/*

force -freeze sim:/mips/clk 0 0, 1 {50 ps} -r 100
force -freeze sim:/mips/reset 1 0
run 50 ps
force -freeze sim:/mips/reset 0 0

