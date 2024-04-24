`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/22 10:01:52
// Design Name: 
// Module Name: baud_generate
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
module baud_generate
# (
    parameter clk_rate  = 100_000_000 ,
    parameter baud_rate = 9600
  )
  ( 
    input   baud_clk ,
    input   baud_rst_n,
    output  tx_clk ,
    output  rx_clk
  );


    //不同的波特率所需计数次数：时钟频率 / 波特率
    localparam tx_rate = clk_rate / baud_rate ;
    localparam rx_rate = clk_rate / baud_rate / 16 ;

    reg [$clog2(tx_rate) - 1 : 0] tx_clk_cnt ;
    reg [$clog2(rx_rate) - 1 : 0] rx_clk_cnt ;

    reg tx_clk_reg ;
    reg rx_clk_reg ;

    always @(posedge baud_clk or negedge baud_rst_n) begin
        if(!baud_rst_n) begin
            tx_clk_cnt <= 'b0 ;
            tx_clk_reg <= 1'b0 ;
        end
        else begin
            if(tx_clk_cnt == tx_rate - 1) begin
                tx_clk_cnt <= 'b0 ;
                tx_clk_reg <= !tx_clk_reg ;
            end
            else begin
                tx_clk_cnt <= tx_clk_cnt + 1'b1 ;
                tx_clk_reg <= tx_clk_reg ;
            end
        end
    end

    always @(posedge baud_clk or negedge baud_rst_n) begin
        if(!baud_rst_n) begin
            rx_clk_cnt <= 'b0 ;
            rx_clk_reg <= 1'b0 ;
        end
        else begin
            if(rx_clk_cnt == rx_rate - 1) begin
                rx_clk_cnt <= 'b0 ;
                rx_clk_reg <= !rx_clk_reg ;
            end
            else begin
                rx_clk_cnt <= rx_clk_cnt + 1'b1 ;
                rx_clk_reg <= rx_clk_reg ;
            end
        end
    end

    assign tx_clk = tx_clk_reg ;
    assign rx_clk = rx_clk_reg ;
    
endmodule
