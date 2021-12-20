quit -sim
vsim -gui work.mips
 
mem load -i E:/Modelsim/Pipeline_Processor/bin.mem /mips/insrcMem/ram
add wave -position insertpoint sim:/mips/*

force -freeze sim:/mips/clk 0 0, 1 {50 ps} -r 100
force -freeze sim:/mips/reset 1 0
run 50
force -freeze sim:/mips/reset 0 0

