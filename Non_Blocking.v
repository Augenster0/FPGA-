`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/19 10:20:31
// Design Name: 
// Module Name: Non_Blocking
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


module Non_Blocking(
    input       clk ,
    input wire  a ,
    output reg  b,
    output reg  c
    );

    // 非阻塞赋值
    always@(posedge clk) begin
        b <= a ;
        c <= b ;
    end
    /*
    always@(posedge clk) begin
        b = a ;
        c = b ;
    end
    */

endmodule
