/************************************************
*module name: spi_slve
* file name :spi_module.v
* Description: this module is spi_slave module used to coomunicate with ram module 
* module auther:Kirollos Gerges Sobhy
***************************************************/
module spi_slave(clk,rst_n,ss_n,mosi,tx_valid,tx_data,rx_data,rx_valid,miso);

/*******************************************************
                parmeters
******************************************************/
parameter IDLE=3'b000;
parameter CHK_CMD=3'b001;
parameter WRITE=3'b010;
parameter READ_ADD=3'b011;
parameter READ_DATA=3'b100;

/*******************************************************
                inputs
******************************************************/
input clk,rst_n,ss_n,mosi,tx_valid;
input [7:0] tx_data;
/*******************************************************
                 outputs
******************************************************/
output reg rx_valid,miso;
output reg [9:0]rx_data;
/*******************************************************
                 other internal register
******************************************************/
reg [3:0] count,count_2;/* to count the bits  */
reg add_or_data;/*to determine wich state we are gonna go from the check command */
reg [2:0] cs ,ns;/*current state and next state*/
reg [9:0] bus;//to turn from serial to parallel
reg [7:0] bus2;//to take the tx_data

/**********************************************************************
 *                    state memory
*********************************************************************/
always @(posedge clk or negedge rst_n) begin
  if (~rst_n) begin
    cs<= IDLE;
  end
  else 
    cs<=ns;
  
end
/**********************************************************************
 *                   next state logic
*********************************************************************/

always @(*)begin
  case(cs)
    IDLE:begin
      if(ss_n)
        ns=IDLE;
      else 
        ns=CHK_CMD; 
    end
     CHK_CMD:begin 
      if(ss_n)
        ns=IDLE;
      else begin
          if(mosi)begin
            if(add_or_data)/*if add_or_data==1 then we read address first*/
              ns<=READ_DATA;
            else begin
              ns<=READ_ADD;
            end
          end
          else begin
            ns<=WRITE;
          end

      end
    end
     WRITE:begin
        if(ss_n)
          ns=IDLE;
        else 
          ns=WRITE;
    end
     READ_ADD:begin 
        if(ss_n)
          ns=IDLE;
        else 
          ns=READ_ADD;
    end
     READ_DATA:begin 
        if(ss_n)
          ns=IDLE;
        else 
          ns=READ_DATA;
    end
    default:begin 
      ns=IDLE;
    end
  endcase
end
/**********************************************************************
 *                   output logic
*********************************************************************/
always @(posedge clk)begin
  case(cs)
    WRITE:begin
      bus[count-1]<=mosi;
      count<=count-1;
      if(count==0)begin
        count<=10;
        rx_valid<=1;
        rx_data<=bus;
      end

    end
    READ_ADD:begin
      bus[count-1]<=mosi;
      count<=count-1;
      if(count==0)begin
        count<=10;
        rx_valid<=1;
        rx_data<=bus;
        add_or_data<=1;
      end
    end
    READ_DATA:begin
      if(~tx_valid)begin    
        bus[count-1]<=mosi;
        count<=count-1;
        if(count==0)begin
          count<=10;
          rx_valid<=1;
          rx_data<=bus;
          add_or_data<=0;
        end
      end
      else begin
        bus2<=tx_data;
        miso<=bus2[count_2-1];
        count_2=count_2-1;
        if(count_2==0)
        count_2<=8;
      end
    end
    IDLE:begin
    rx_valid<=0;
    count<=10;
    count_2<=8;
    miso<=0;
    bus<=0;
    bus2<=0; 
    end
  endcase
end 

endmodule