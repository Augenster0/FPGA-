// `timescale 1ns / 1ps
// //////////////////////////////////////////////////////////////////////////////////
// // Company: 
// // Engineer: 
// // 
// // Create Date: 2024/04/21 13:47:02
// // Design Name: 
// // Module Name: seq_det
// // Project Name: 
// // Target Devices: 
// // Tool Versions: 
// // Description: 
// // 
// // Dependencies: 
// // 
// // Revision:
// // Revision 0.01 - File Created
// // Additional Comments:
// // 
// //////////////////////////////////////////////////////////////////////////////////


module seq_det(
    input   clk ,
    input   rst_n ,
    input   seq_data ,
    output reg seq_det
    );

reg [2:0] state , next_state ;

parameter
    Idle = 3'b000 ,
    S1   = 3'b001 ,
    S2   = 3'b010 ,
    S3   = 3'b011 ,
    S4   = 3'b100 ,
    S5   = 3'b101 ;
    // S6   = 3'b110 ;
//----------每一时钟沿产生一次可能的状态变化----------
always@(posedge clk or negedge rst_n) begin
    if(!rst_n)
        state <= Idle ;
    else 
        state <= next_state ;
end
//---------------------------------------------------
//-----------------产生下一状态的组合逻辑--------------
always@(*) begin
    case(state)
        Idle:
            if(seq_data == 1) 
                next_state = S1 ;
            else
                next_state = Idle ;
        S1:
            if(seq_data == 0)
                next_state = S2 ;
            else
                next_state = S1 ;
        S2:
            if (seq_data == 0)
                next_state = S3 ;
            else
                next_state = S1 ;
        S3:
            if(seq_data == 1)
                next_state = S4 ;
            else
                next_state = Idle ;
        S4:
            if(seq_data == 0)
                next_state = S5 ;
            else
                next_state = S1 ;
        S5:
            if(seq_data == 0)
                next_state = S3 ;
            else
                next_state = S1 ;
        default:
            next_state     = Idle ;
    endcase
end
//---------------------------------------------------
//---------------产生所需的组合或时序逻辑--------------
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        seq_det <= 1'b0;
    end
    else begin
        case(state)
            S5:
                seq_det <= 1'b1 ;
            default:
                seq_det <= 1'b0 ;
        endcase
    end
end
endmodule