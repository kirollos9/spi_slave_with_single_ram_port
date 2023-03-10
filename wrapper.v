module spi_ram(clk,rst_n,ss_n,mosi,miso);
input clk,rst_n,ss_n,mosi;
output miso;
wire tx_valid,rx_valid;
wire [7:0] tx_data;
wire [9:0]rx_data;
ram r(clk,rst_n,rx_valid,rx_data,tx_valid,tx_data);
spi_slave s(clk,rst_n,ss_n,mosi,tx_valid,tx_data,rx_data,rx_valid,miso);
endmodule