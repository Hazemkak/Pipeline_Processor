quit -sim
vsim -gui work.mips
 
mem load -i C:/Users/user/Desktop/Pipeline_Processor/bin.mem /mips/insrcMem/ram
mem load -i C:/Users/user/Desktop/Pipeline_Processor/data.mem /mips/memo/ram_arr

add wave -position insertpoint  \
sim:/mips/clk \
sim:/mips/reset \
sim:/mips/datain \
sim:/mips/dataout \
sim:/mips/InputPort \
sim:/mips/PC_sel \
sim:/mips/PC \
sim:/mips/newPC \
sim:/mips/instraction \
sim:/mips/controls \
sim:/mips/alu_out \
sim:/mips/ex/outputZF \
sim:/mips/ex/outputNF \
sim:/mips/ex/outputCF \
sim:/mips/sp_data \
sim:/mips/exception \
sim:/mips/exceptionProgramCounterReg/EPC_data \
sim:/mips/address \
sim:/mips/memoAddress \
sim:/mips/mem_out \
sim:/mips/regFile/qreg0 \
sim:/mips/regFile/qreg1 \
sim:/mips/regFile/qreg2 \
sim:/mips/regFile/qreg3 \
sim:/mips/regFile/qreg4 \
sim:/mips/regFile/qreg5 \
sim:/mips/regFile/qreg6 \
sim:/mips/regFile/qreg7 


force -freeze sim:/mips/clk 0 0, 1 {50 ps} -r 100
force -freeze sim:/mips/reset 1 0
force -freeze sim:/mips/datain 0000 0

run 50ps
force -freeze sim:/mips/reset 0 0
