`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/18 17:39:51
// Design Name: 
// Module Name: bit_4_cnt_10_tb
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


module bit_4_cnt_10_tb();

    reg             clk ;
    reg             rst_n;
    wire    [3:0]   cnt_out;
    wire            cout;

    //初始化
    initial begin
        clk = 0 ;
        rst_n = 0 ;
    end

    //产生激励
    always #10 clk = ~clk ;

    always@(posedge clk) begin
        #100 ;
        rst_n = 1'b1 ;
        #200000 ;
        $stop ;
    end

    bit_4_cnt_10 inst_bit_4_cnt_10 (
        .clk     (clk), 
        .rst_n   (rst_n), 
        .cnt_out (cnt_out), 
        .cout    (cout)
        );

endmodule
