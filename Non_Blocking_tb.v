`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/19 10:21:43
// Design Name: 
// Module Name: Non_Blocking_tb
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


module Non_Blocking_tb();

    reg     clk ;
    reg     a ;
    wire    b ;
    wire    c ;

    initial begin
        clk = 0 ;
        a = 0 ;
    end

    always #10 clk = ~clk ;
    always #20 a = ~a ;

    initial begin
        #6000 ;
        $finish();
    end

        Non_Blocking inst_Non_Blocking (.clk(clk), .a(a), .b(b), .c(c));

endmodule
