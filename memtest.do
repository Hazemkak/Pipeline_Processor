#compileall projects
project compileall

vsim -gui work.mips

add wave -position insertpoint sim:/mips/*
mem load -i {C:/Users/kc/Downloads/3rd CMP/Architecture/Project/bin.mem} -format mti /mips/insrcMem/ram
mem load -filltype inc -filldata 16'h0 -fillradix hexadecimal -skip 0 /mips/memo/ram_arr
force -freeze sim:/mips/clk 0 0, 1 {50 ns} -r 100
force -freeze sim:/mips/reset 1 0
run 50

force -freeze sim:/mips/reset 0 0
run