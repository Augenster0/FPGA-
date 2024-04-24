`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/23 20:31:48
// Design Name: 
// Module Name: rx_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`timescale 1ns / 1ps
module rx_tb();
reg rx_clk;
reg rx_rst_n;
reg rx_data;
wire fail;
wire [7:0] rx_data_out;

reg test;

rx#(
    .WIDTH     ( 8 ),
    .stop_bit  ( 2 ),
    .test      ( 1 )
)u_rx(
    .rx_clk    ( rx_clk    ),
    .rx_rst_n  ( rx_rst_n  ),
    .rx_data   ( rx_data   ),
    .fail      ( fail      ),
    .rx_data_out  ( rx_data_out  )
);


initial rx_clk = 0;
always #5 rx_clk = !rx_clk;

task receive_data;
input [7:0] A;
begin

repeat(16)@(negedge rx_clk);
    rx_data = 0;
    test = ^A;

repeat(8) 
	begin
	repeat(16)@(negedge rx_clk);
	rx_data = A[0];
	A = A>>1;
	end

repeat(16)@(negedge rx_clk);
	rx_data = test;

repeat(16)@(negedge rx_clk);
	rx_data = 1;

repeat(16)@(negedge rx_clk);
	rx_data = 1;
#200;
end
endtask


initial
begin
rx_rst_n=1;
rx_data = 1;
#15
rx_rst_n=0;
#50
rx_rst_n=1;
#30;
receive_data(8'h34);
receive_data(8'ha8);
receive_data(8'hb4);
end

endmodule

