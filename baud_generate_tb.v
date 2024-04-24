`timescale 1ns / 1ps
module baud_generate_tb ();
    reg clk;
    reg rst_n;
    wire rx_clk;
    wire tx_clk;

    baud_generate #(10_000_000,9600) u1 (clk,rst_n,tx_clk,rx_clk);

    initial clk = 0;
    always #5 clk = !clk; //生成10ns全局时钟

    initial 
        begin
        rst_n = 1;
        rst_n = 0;
        #45
        rst_n = 1;
        #4000000000;
        $stop;
        end

endmodule
