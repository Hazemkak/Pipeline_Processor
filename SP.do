vsim -gui work.stackpointer

add wave -position insertpoint sim:/stackpointer/*

force -freeze sim:/stackpointer/reset 1 0
force -freeze sim:/stackpointer/clk 1 0, 0 {50 ns} -r 100
run
run
force -freeze sim:/stackpointer/SP 3'h001 0
force -freeze sim:/stackpointer/reset 0 0
run
run
force -freeze sim:/stackpointer/SP 3'b111 0
run