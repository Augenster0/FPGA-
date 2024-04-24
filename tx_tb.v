`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/23 14:44:53
// Design Name: 
// Module Name: tx_tb
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


module tx_tb();

    reg tx_clk ;
    reg tx_rst_n ;
    reg tx_en ;
    reg [7:0] tx_data ;
    wire tx_done ;
    wire tx_data_out ;

    tx#(
    .WIDTH     ( 8 ),
    .stop_bit  ( 2 ),
    .test      ( 1 )
)u_tx(
    .tx_clk    ( tx_clk    ),
    .tx_rst_n  ( tx_rst_n  ),
    .tx_en     ( tx_en     ),
    .tx_data   ( tx_data   ),
    .tx_done   ( tx_done   ),
    .tx_data_out  ( tx_data_out  )
);

    initial tx_clk = 0 ;
    always #5 tx_clk = !tx_clk ;

    //数据发送任务
    task write_data;
    input [7:0] task_data_in ;
    begin
        @(negedge tx_clk) ;
            tx_en = 1 ;
        @(negedge tx_clk) ;
            tx_data = task_data_in ;
            tx_en = 0 ;
        repeat(12) @(negedge tx_clk) ;
    end
    endtask

    initial begin
        tx_rst_n = 1 ;
        tx_en = 0 ;
        #15
        tx_rst_n = 0 ;
        #50
        tx_rst_n = 1 ;
        #30
        write_data(8'h0a) ;
        write_data(8'h24) ;
        write_data(8'h33) ;
        write_data(8'h14) ;        
    end

endmodule
