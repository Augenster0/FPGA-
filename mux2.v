`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/18 20:47:16
// Design Name: 
// Module Name: mux2
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


module mux2(
    input wire  a ,
    input wire  b ,
    input wire  sl ,
    output wire out
    );

    not u1 (nsl , sl) ;
    and u2 (sela , a , nsl) ;
    and u3 (selb , sl , b) ;
     or u4 (out , sela , selb);

endmodule
