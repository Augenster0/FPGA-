`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/22 10:01:52
// Design Name: 
// Module Name: tx
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


module tx
   #(
        parameter WIDTH = 8 ,
        parameter stop_bit = 2 ,
        parameter test = 2
    )
    (
    input tx_clk ,
    input tx_rst_n ,
    input tx_en ,
    input [WIDTH - 1 : 0] tx_data ,
    output reg tx_done ,
    output reg tx_data_out
    );
 
//  状态机实现数据发送
    reg [2:0] state , n_state ;
    parameter Idle = 3'b001 ,
              S1 = 3'b010 ,
              S2 = 3'b011,
              S3 = 3'b100,
              S4 = 3'b101,
              S5 = 3'b110;
    
    always@(posedge tx_clk or negedge tx_rst_n) begin
        if(!tx_rst_n) begin
            state <= 3'b0 ;
        end
        else begin
            state <= n_state ;
        end
    end

// bit_count用于记录发了几位数据
    reg [2:0] bit_count ;
    always@(posedge tx_clk or negedge tx_rst_n) begin
        if(!tx_rst_n) begin
            bit_count <= 3'b0 ;
        end
        else begin
            if(state == S2 && bit_count <= WIDTH - 1) begin
                bit_count <= bit_count + 1'b1 ;
            end
            else begin
                bit_count <= 3'b0 ;
            end
        end
    end
// stop_count用于记录发了几位停止位
    reg [1:0] stop_count ;
    always@(posedge tx_clk or negedge tx_rst_n) begin
        if(!tx_rst_n) begin
            stop_count <= 2'b0 ;
        end
        else begin
            if(state == S4 && stop_count <= stop_bit - 1) begin
                stop_count <= stop_count + 1'b1 ;
            end
            else begin
                stop_count <= 2'b0 ;
            end
        end        
    end

    always@(posedge tx_clk or negedge tx_rst_n) begin
        if(!tx_rst_n) begin
            tx_done <= 1'b0 ;
        end
        else begin
            if(stop_count == stop_bit) begin
                tx_done <= 1'b1 ;
            end
            else begin
                tx_done <= 1'b0 ;
            end
        end        
    end

// 校验位
    reg check_bit ;
    always@(posedge tx_clk or negedge tx_rst_n) begin
        if(!tx_rst_n) begin
            check_bit <= 1'b0 ;
        end
        else begin
            if(state == S3) begin
                case(test)
                    2'b00:
                        check_bit <= 1'b0 ;
                    2'b01:
                        check_bit <= !(^tx_data) ;
                    2'b10:
                        check_bit <= ^tx_data ;
                    default:
                        check_bit <= 1'b0 ; 
                endcase
            end
            else begin
                check_bit <= check_bit ;
            end
        end
    end

    always@(*) begin
        case(state)
            Idle:
                begin
                    if(tx_en) begin
                        n_state <= S1 ;
                    end
                    else begin
                        n_state <= Idle ;
                    end
                end
            S1:
                begin
                    n_state <= S2 ;
                end
            S2:
                begin
                    if(bit_count == (WIDTH - 1)) begin
                        if(test) begin
                            n_state <= S3 ;
                        end
                        else begin
                            n_state <= S4 ;
                        end
                    end
                    else begin
                        n_state <= S2 ;
                    end
                end
            S3:
                begin
                    n_state <= S4 ;
                end
            S4:
                begin
                    if(stop_count == (stop_bit - 1)) begin
                        n_state <= Idle ;
                    end
                    else begin
                        n_state <= S4 ;
                    end
                end
            default:
                begin
                    n_state <= Idle ;
                end
        endcase
    end

    always@(*) begin
        case(state)
            Idle:
                tx_data_out <= 1'b1 ;
            S1:
                tx_data_out <= 1'b0 ;
            S2:
                tx_data_out <= tx_data[bit_count] ;
            S3:
                tx_data_out <= check_bit ;
            S4:
                tx_data_out <= 1'b1 ;
            default:
                tx_data_out <= 1'b1 ;
        endcase
    end

endmodule