`timescale 1ns / 1ps
// //////////////////////////////////////////////////////////////////////////////////
// // Company: 
// // Engineer: 
// // 
// // Create Date: 2024/04/21 14:35:39
// // Design Name: 
// // Module Name: seq_det_tb
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


module seq_det_tb();

    reg         clk ;
    reg         rst_n ;
    reg [23:0]  seq_data ;
    wire        seq_det ;

    wire        x ;
    assign x = seq_data[23] ;



    initial begin
        clk      = 0 ;
        rst_n    = 0 ;
        seq_data = 0;
        #201 ;
        rst_n    = 1 ;
        seq_data = 20'b1100_1001_0000_1001_0100 ;
        #100000 ;
        $finish();
    end

    always #10 clk = ~clk ;

    always@(posedge clk)
        #2 seq_data = {seq_data[22:0],seq_data[23]} ;

    seq_det inst_seq_det (
        .clk      (clk),
        .rst_n    (rst_n),
        .seq_data (x),
        .seq_det  (seq_det)
    );

endmodule
