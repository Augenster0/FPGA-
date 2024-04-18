`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/18 17:10:34
// Design Name: 
// Module Name: 4bit_cnt
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
module bit_4_cnt_10(
    input           clk,
    input           rst_n,
    output  [3:0]   cnt_out,
    output          cout
    );

    reg [3:0] cnt;
    always @(posedge clk or negedge rst_n) begin
         if(!rst_n) begin
            cnt <= #1 4'b0 ;
         end
         else begin
            if(cnt >= 4'd9) begin
                cnt <= #1 4'd0 ;
            end 
            else begin
                cnt <= #1 cnt + 1'd1 ;
            end
         end
     end 

    assign cout    = (cnt == 4'd9) ;
    assign cnt_out = cnt ;
endmodule
