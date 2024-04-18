`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/18 20:47:47
// Design Name: 
// Module Name: mux2_tb
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


module mux2_tb;

    reg     a ;
    reg     b ;
    reg     sl ;
    wire    out;

    initial begin
        a  = 0 ;
        b  = 1 ;
        sl = 0;
    end

    always #10 a    = ~a ;//always不能写在initial块里面
    always #20 b    = ~b ;
    always #1000 sl = ~sl ;

    //仿真暂停
    initial begin
        #10000 
        $finish();//finish不能写在initial块外面
    end

    mux2 inst_mux2 (
        .a   (a), 
        .b   (b), 
        .sl  (sl), 
        .out (out)
        );
endmodule
