`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/22 10:01:52
// Design Name: 
// Module Name: rx
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
//���ն˵Ĵ�������ڽ��ն˸�����
//������baud_set���Ѿ���rx��ʱ��16��Ƶ�ˣ�����ֻ��Ҫһ��������������16�Ͷ�Ӧtx��һ��ʱ������
//�½��ؼ���ж��Ƿ�ʼ��������

module rx
   #(
        parameter WIDTH = 8 ,
        parameter stop_bit = 2 ,
        parameter test = 2
    )
    (
    input rx_clk ,
    input rx_rst_n ,
    input rx_data ,
    output fail ,
    output [WIDTH - 1 : 0] rx_data_out
    );
// ��������
reg [2:0] state , n_state ;
parameter Idle = 3'b000 ,
          S1 = 3'b001 ,
          S2 = 3'b010,
          S3 = 3'b011,
          S4 = 3'b100;


//�½��ؼ�� ��ʼ�������ݵı�־λ
reg rx_data_r ;
always@(posedge rx_clk or negedge rx_rst_n) begin
    if(!rx_rst_n) begin
        rx_data_r <= 1'b0 ;
    end
    else begin
        rx_data_r <= rx_data ;
    end
end

wire n_edge ;
assign n_edge = (!rx_data) & (rx_data_r) ;

//����16��Ƶ��ʱ��ʵ�ּ�����
reg [3:0] fre_16 ; //���������ÿ��16�Σ����Ͷ˷���һbit����
reg [2:0] bit_count ; 
reg [1:0] stop_count ;

always@(posedge rx_clk or negedge rx_rst_n) begin
    if(!rx_rst_n) begin
        fre_16 <= 4'b0000 ;
    end
    else begin
        if(fre_16 == 4'b1111 || state == Idle) begin //��������ǻ�Ҳ�������룬��Ļ����Ǽ���������Զ�����
            fre_16 <= 4'b0000 ;
        end
        else begin
            if(state == S1 || state == S2 || state == S3 || state == S4) begin
                fre_16 <= fre_16 + 1'b1 ;
            end
            else begin
                fre_16 <= fre_16 ;
            end
        end
    end
end

reg filter_out ;
reg [15:0] filter_reg ;

//��16��Ƶ�Ľ�����ڼĴ�����
always@(posedge rx_clk or negedge rx_rst_n) begin
    if(!rx_rst_n) begin
        filter_reg <= 16'h0000 ;
    end
    else begin
        if(state == S1 || state == S2 || state == S3 || state == S4) begin
            filter_reg[fre_16] <= rx_data ;
        end
        else begin
            filter_reg <= 16'h0000 ;
        end
    end
end

//ȡ������16�������е�7 8 9��λ���м�⣬�õ���Ϊ׼ȷ�Ľ��
always@(posedge rx_clk or negedge rx_rst_n) begin
    if(!rx_rst_n || state == Idle) begin
        filter_out <= 1'b0 ;
    end
    else begin
        if(fre_16 == 4'b1100) begin
            filter_out <= ((filter_reg[7] & filter_reg[8]) ^ (filter_reg[7] & filter_reg[9]) ^ (filter_reg[8] & filter_reg[9]));
        end
        else begin
            filter_out <= filter_out ;
        end
    end
end

always@(posedge rx_clk or negedge rx_rst_n) begin
    if(!rx_rst_n || state !== S2) begin
        bit_count <= 3'b000 ;
    end
    else begin
        if(fre_16 == 4'b1111 && bit_count == WIDTH -1) begin
            bit_count <= 3'b0 ;
        end
        else begin
            if(fre_16 == 4'b1111) begin
                bit_count <= bit_count + 1'b1 ;
            end
            else begin
                bit_count <= bit_count ;
            end
        end
    end
end

always@(posedge rx_clk or negedge rx_rst_n) begin
    if(!rx_rst_n || state !== S4) begin
        stop_count <= 2'b00 ;
    end
    else begin
        if(fre_16 == 4'b1111 && stop_count == stop_bit -1) begin
            stop_count <= 2'b00 ;
        end
        else begin
            if(fre_16 == 4'b1111) begin
                stop_count <= stop_count + 1'b1 ;
            end
            else begin
                stop_count <= stop_count ;
            end
        end
    end
end

//״̬��ʵ�����ݽ���
//����ʽ״̬����һ��
always@(posedge rx_clk or negedge rx_rst_n) begin
    if(!rx_rst_n) begin
        state <= Idle ;
    end
    else begin
        state <= n_state ;
    end
end

//����ʽ״̬���ڶ���
always@(*) begin
    case(state) 
        Idle:
            begin
                if(n_edge) begin
                    n_state <= S1 ;
                end
                else begin
                    n_state <= Idle ;
                end
            end
        S1:
            begin
                if(fre_16 == 4'b1111) begin
                    n_state <= S2 ;
                end
             else begin
                 n_state <= S1 ;
             end
            end
        S2:
            begin
                if((fre_16 == 4'b1111) && bit_count == WIDTH - 1) begin
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
                if(fre_16 == 4'b1111) begin
                    n_state <= S4 ;
                end
                else begin
                    n_state <= S3 ;
                end
            end
        S4:
            begin
                if(stop_count == (stop_bit - 1) && fre_16 == 4'b1111) begin
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

//����ʽ״̬��������
reg [WIDTH - 1 : 0] rx_data_reg ;
always@(posedge rx_clk or negedge rx_rst_n) begin
    if(!rx_rst_n || state == Idle) begin
        rx_data_reg <= 'b0 ;
    end
    else begin
        if(state == S2 && fre_16 == 4'b1111) begin
            rx_data_reg[bit_count] <= filter_out ;
        end
        else begin
            rx_data_reg <= rx_data_reg ;
        end
    end
end

reg test_reg;
always@(posedge rx_clk or negedge rx_rst_n) begin
    if(!rx_rst_n) begin
        test_reg <= 1'b0 ;
    end
    else begin
        if(state == S3) begin
            case(test) 
                2'b00:
                    test_reg <= 1'b0 ;
                2'b01:
                    test_reg <= !(^rx_data_reg) ;
                2'b10:
                    test_reg <= (^rx_data_reg) ;
                default:
                    test_reg <= 1'b0 ;
            endcase 
        end
        end
    end

assign fail = (state == S3 && fre_16 == 4'b1110 && filter_out != test_reg) ? 1 : 0 ;

assign rx_data_out = (state == S4 && stop_count == stop_bit - 1) ? rx_data_reg : 'b0 ;

endmodule