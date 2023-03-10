vlib work
vlog ram.v spi_module.v wrapper.v wrapper_tb.v
vsim -voptargs=+acc work.wrapper_tb
add wave -position insertpoint  \
sim:/wrapper_tb/clk
add wave -position insertpoint  \
sim:/wrapper_tb/rst_n
add wave -position insertpoint  \
sim:/wrapper_tb/ss_n
add wave -position insertpoint  \
sim:/wrapper_tb/mosi
add wave -position insertpoint  \
sim:/wrapper_tb/miso
add wave -position insertpoint  \
sim:/wrapper_tb/sr/tx_valid
add wave -position insertpoint  \
sim:/wrapper_tb/sr/rx_valid
add wave -position insertpoint  \
sim:/wrapper_tb/sr/tx_data
add wave -position insertpoint  \
sim:/wrapper_tb/sr/rx_data
add wave -position insertpoint  \
{sim:/wrapper_tb/sr/r/mem[10]}
run -all