`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/24 11:24:53
// Design Name: 
// Module Name: top_tb
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
module top_tb();
reg clk;
reg rst_n;
reg enable;
reg [7:0] data_in;
wire [7:0] rx_out;

top  u4(clk,rst_n,enable,data_in,rx_out);

initial clk = 0;
always #5 clk = !clk;

initial
begin
rst_n = 1;
#2000;
rst_n = 0;
enable = 1;
#2000;
rst_n = 1;
data_in = 8'h34;
#20000000;
$stop;
end
endmodule

