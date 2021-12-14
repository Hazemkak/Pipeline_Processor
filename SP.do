vsim -gui work.stackpointer

add wave -position insertpoint sim:/stackpointer/*
force -freeze sim:/stackpointer/reset 1 0
force -freeze sim:/stackpointer/clk 1 0, 0 {50 ns} -r 100
run
force -freeze sim:/stackpointer/SP 3'h100 0
run
force -freeze sim:/stackpointer/reset 0 0
force -freeze sim:/stackpointer/SP 3'b010 0
run
#decrement by 1
force -freeze sim:/stackpointer/SP 3'b001 0
run
run

#increment by 2
force -freeze sim:/stackpointer/SP 3'b111 0
run