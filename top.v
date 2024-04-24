`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/24 11:24:31
// Design Name: 
// Module Name: top
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


module top#(
parameter time_frequency = 100_000_000,
parameter baud_rate = 9_600,
parameter data_width = 8,
parameter test = 1,
parameter stop_width = 2
)(
input clk,
input rst_n,
input enable,
input [data_width-1:0] data_in,
output [data_width-1:0] rx_out);

wire rx_clk;
wire tx_clk;
wire tx_out;

baud_generate#
        (time_frequency,baud_rate)
    u_baud_generate
    (
        .baud_clk   ( clk   ),
        .baud_rst_n ( rst_n ),
        .tx_clk     ( tx_clk     ),
        .rx_clk     ( rx_clk     )
    );


tx#
    (
        data_width , stop_width , test
    )
    u_tx
    (
        .tx_clk    ( tx_clk    ),
        .tx_rst_n  ( rst_n  ),
        .tx_en     ( enable     ),
        .tx_data   ( data_in   ),
        .tx_done   (),
        .tx_data_out  ( tx_out  )
    );


rx#
    (
        data_width , stop_width , test
    )
    u_rx
    (
        .rx_clk    ( rx_clk    ),
        .rx_rst_n  ( rst_n  ),
        .rx_data   ( tx_out   ),
        .fail      (),
        .rx_data_out  ( rx_out )
    );

endmodule

