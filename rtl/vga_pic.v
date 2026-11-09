`timescale 1ns/1ns
module vga_pic (
    input  wire        vga_clk,
    input  wire        sys_rst_n,
    input  wire [9:0]  pix_x,
    input  wire [9:0]  pix_y,
    input  wire [1:0]  pic_state,
    output reg  [15:0] pix_data
);


localparam BARS = 2'b00;
localparam MUST = 2'b01;
localparam END  = 2'b10;


parameter WHITE      = 16'hFFFF;
parameter BLACK      = 16'h0000;
parameter RED        = 16'hF800;
parameter ORANGE     = 16'hFC00;
parameter YELLOW     = 16'hFFE0;
parameter GREEN      = 16'h07E0;
parameter LIGHT_BLUE = 16'h07FF;
parameter BLUE       = 16'h001F;
parameter PURPLE     = 16'hF81F;
parameter LIGHT_GRAY = 16'hD69A;


parameter [7:0] M_ROW_0 = 8'b1100_0011;
parameter [7:0] M_ROW_1 = 8'b1110_0111;
parameter [7:0] M_ROW_2 = 8'b1111_1111;
parameter [7:0] M_ROW_3 = 8'b1101_1011;
parameter [7:0] M_ROW_4 = 8'b1100_0011;
parameter [7:0] M_ROW_5 = 8'b1100_0011;
parameter [7:0] M_ROW_6 = 8'b1100_0011;
parameter [7:0] M_ROW_7 = 8'b1100_0011;

parameter [7:0] U_ROW_0 = 8'b1100_0011;
parameter [7:0] U_ROW_1 = 8'b1100_0011;
parameter [7:0] U_ROW_2 = 8'b1100_0011;
parameter [7:0] U_ROW_3 = 8'b1100_0011;
parameter [7:0] U_ROW_4 = 8'b1100_0011;
parameter [7:0] U_ROW_5 = 8'b1100_0011;
parameter [7:0] U_ROW_6 = 8'b1100_0011;
parameter [7:0] U_ROW_7 = 8'b0111_1110;

parameter [7:0] S_ROW_0 = 8'b0111_1110;
parameter [7:0] S_ROW_1 = 8'b1100_0111;
parameter [7:0] S_ROW_2 = 8'b1110_0000;
parameter [7:0] S_ROW_3 = 8'b0111_1100;
parameter [7:0] S_ROW_4 = 8'b0000_1110;
parameter [7:0] S_ROW_5 = 8'b0000_0111;
parameter [7:0] S_ROW_6 = 8'b1110_0111;
parameter [7:0] S_ROW_7 = 8'b0111_1100;

parameter [7:0] T_ROW_0 = 8'b1111_1111;
parameter [7:0] T_ROW_1 = 8'b0001_1000;
parameter [7:0] T_ROW_2 = 8'b0001_1000;
parameter [7:0] T_ROW_3 = 8'b0001_1000;
parameter [7:0] T_ROW_4 = 8'b0001_1000;
parameter [7:0] T_ROW_5 = 8'b0001_1000;
parameter [7:0] T_ROW_6 = 8'b0001_1000;
parameter [7:0] T_ROW_7 = 8'b0001_1000;


parameter [7:0] E_ROW_0 = 8'b1111_1111;
parameter [7:0] E_ROW_1 = 8'b1100_0000;
parameter [7:0] E_ROW_2 = 8'b1100_0000;
parameter [7:0] E_ROW_3 = 8'b1111_1100;
parameter [7:0] E_ROW_4 = 8'b1100_0000;
parameter [7:0] E_ROW_5 = 8'b1100_0000;
parameter [7:0] E_ROW_6 = 8'b1100_0000;
parameter [7:0] E_ROW_7 = 8'b1111_1111;

parameter [7:0] N_ROW_0 = 8'b1100_0011;
parameter [7:0] N_ROW_1 = 8'b1110_0011;
parameter [7:0] N_ROW_2 = 8'b1111_0011;
parameter [7:0] N_ROW_3 = 8'b1111_1011;
parameter [7:0] N_ROW_4 = 8'b1101_1111;
parameter [7:0] N_ROW_5 = 8'b1100_1111;
parameter [7:0] N_ROW_6 = 8'b1100_0111;
parameter [7:0] N_ROW_7 = 8'b1100_0011;

parameter [7:0] D_ROW_0 = 8'b1111_1100;
parameter [7:0] D_ROW_1 = 8'b1100_0111;
parameter [7:0] D_ROW_2 = 8'b1100_0011;
parameter [7:0] D_ROW_3 = 8'b1100_0011;
parameter [7:0] D_ROW_4 = 8'b1100_0011;
parameter [7:0] D_ROW_5 = 8'b1100_0011;
parameter [7:0] D_ROW_6 = 8'b1100_0111;
parameter [7:0] D_ROW_7 = 8'b1111_1100;


parameter CHAR_SIZE = 10'd64;


parameter M_X = 10'd96;
parameter U_X = 10'd224;
parameter S_X = 10'd352;
parameter T_X = 10'd480;
parameter CHAR_Y = 10'd208;


parameter E_X = 10'd160;
parameter N_X = 10'd288;
parameter D_X = 10'd416;


wire in_m_box, in_u_box, in_s_box, in_t_box;
assign in_m_box = (pix_x >= M_X) && (pix_x < M_X + CHAR_SIZE)
               && (pix_y >= CHAR_Y) && (pix_y < CHAR_Y + CHAR_SIZE);
assign in_u_box = (pix_x >= U_X) && (pix_x < U_X + CHAR_SIZE)
               && (pix_y >= CHAR_Y) && (pix_y < CHAR_Y + CHAR_SIZE);
assign in_s_box = (pix_x >= S_X) && (pix_x < S_X + CHAR_SIZE)
               && (pix_y >= CHAR_Y) && (pix_y < CHAR_Y + CHAR_SIZE);
assign in_t_box = (pix_x >= T_X) && (pix_x < T_X + CHAR_SIZE)
               && (pix_y >= CHAR_Y) && (pix_y < CHAR_Y + CHAR_SIZE);

wire [2:0] m_char_x, m_char_y, u_char_x, u_char_y,
           s_char_x, s_char_y, t_char_x, t_char_y;
assign m_char_x = (pix_x - M_X) >> 3;
assign m_char_y = (pix_y - CHAR_Y) >> 3;
assign u_char_x = (pix_x - U_X) >> 3;
assign u_char_y = (pix_y - CHAR_Y) >> 3;
assign s_char_x = (pix_x - S_X) >> 3;
assign s_char_y = (pix_y - CHAR_Y) >> 3;
assign t_char_x = (pix_x - T_X) >> 3;
assign t_char_y = (pix_y - CHAR_Y) >> 3;


wire in_e_box, in_n_box, in_d_box;
assign in_e_box = (pix_x >= E_X) && (pix_x < E_X + CHAR_SIZE)
               && (pix_y >= CHAR_Y) && (pix_y < CHAR_Y + CHAR_SIZE);
assign in_n_box = (pix_x >= N_X) && (pix_x < N_X + CHAR_SIZE)
               && (pix_y >= CHAR_Y) && (pix_y < CHAR_Y + CHAR_SIZE);
assign in_d_box = (pix_x >= D_X) && (pix_x < D_X + CHAR_SIZE)
               && (pix_y >= CHAR_Y) && (pix_y < CHAR_Y + CHAR_SIZE);

wire [2:0] e_char_x, e_char_y, n_char_x, n_char_y, d_char_x, d_char_y;
assign e_char_x = (pix_x - E_X) >> 3;
assign e_char_y = (pix_y - CHAR_Y) >> 3;
assign n_char_x = (pix_x - N_X) >> 3;
assign n_char_y = (pix_y - CHAR_Y) >> 3;
assign d_char_x = (pix_x - D_X) >> 3;
assign d_char_y = (pix_y - CHAR_Y) >> 3;


always @(posedge vga_clk or negedge sys_rst_n) begin
    if (!sys_rst_n)
        pix_data <= BLACK;
    else begin
        case (pic_state)
            
            BARS: begin
                if (pix_x < 10'd64)
                    pix_data <= RED;
                else if (pix_x < 10'd128)
                    pix_data <= ORANGE;
                else if (pix_x < 10'd192)
                    pix_data <= YELLOW;
                else if (pix_x < 10'd256)
                    pix_data <= GREEN;
                else if (pix_x < 10'd320)
                    pix_data <= LIGHT_BLUE;
                else if (pix_x < 10'd384)
                    pix_data <= BLUE;
                else if (pix_x < 10'd448)
                    pix_data <= PURPLE;
                else if (pix_x < 10'd512)
                    pix_data <= BLACK;
                else if (pix_x < 10'd576)
                    pix_data <= WHITE;
                else if (pix_x < 10'd640)
                    pix_data <= LIGHT_GRAY;
                else
                    pix_data <= BLACK;   
            end


            MUST: begin
                if (in_m_box) begin
                    case (m_char_y)
                        3'd0: pix_data <= M_ROW_0[3'd7 - m_char_x] ? WHITE : BLACK;
                        3'd1: pix_data <= M_ROW_1[3'd7 - m_char_x] ? WHITE : BLACK;
                        3'd2: pix_data <= M_ROW_2[3'd7 - m_char_x] ? WHITE : BLACK;
                        3'd3: pix_data <= M_ROW_3[3'd7 - m_char_x] ? WHITE : BLACK;
                        3'd4: pix_data <= M_ROW_4[3'd7 - m_char_x] ? WHITE : BLACK;
                        3'd5: pix_data <= M_ROW_5[3'd7 - m_char_x] ? WHITE : BLACK;
                        3'd6: pix_data <= M_ROW_6[3'd7 - m_char_x] ? WHITE : BLACK;
                        3'd7: pix_data <= M_ROW_7[3'd7 - m_char_x] ? WHITE : BLACK;
                        default: pix_data <= BLACK;
                    endcase
                end
                else if (in_u_box) begin
                    case (u_char_y)
                        3'd0: pix_data <= U_ROW_0[3'd7 - u_char_x] ? WHITE : BLACK;
                        3'd1: pix_data <= U_ROW_1[3'd7 - u_char_x] ? WHITE : BLACK;
                        3'd2: pix_data <= U_ROW_2[3'd7 - u_char_x] ? WHITE : BLACK;
                        3'd3: pix_data <= U_ROW_3[3'd7 - u_char_x] ? WHITE : BLACK;
                        3'd4: pix_data <= U_ROW_4[3'd7 - u_char_x] ? WHITE : BLACK;
                        3'd5: pix_data <= U_ROW_5[3'd7 - u_char_x] ? WHITE : BLACK;
                        3'd6: pix_data <= U_ROW_6[3'd7 - u_char_x] ? WHITE : BLACK;
                        3'd7: pix_data <= U_ROW_7[3'd7 - u_char_x] ? WHITE : BLACK;
                        default: pix_data <= BLACK;
                    endcase
                end
                else if (in_s_box) begin
                    case (s_char_y)
                        3'd0: pix_data <= S_ROW_0[3'd7 - s_char_x] ? WHITE : BLACK;
                        3'd1: pix_data <= S_ROW_1[3'd7 - s_char_x] ? WHITE : BLACK;
                        3'd2: pix_data <= S_ROW_2[3'd7 - s_char_x] ? WHITE : BLACK;
                        3'd3: pix_data <= S_ROW_3[3'd7 - s_char_x] ? WHITE : BLACK;
                        3'd4: pix_data <= S_ROW_4[3'd7 - s_char_x] ? WHITE : BLACK;
                        3'd5: pix_data <= S_ROW_5[3'd7 - s_char_x] ? WHITE : BLACK;
                        3'd6: pix_data <= S_ROW_6[3'd7 - s_char_x] ? WHITE : BLACK;
                        3'd7: pix_data <= S_ROW_7[3'd7 - s_char_x] ? WHITE : BLACK;
                        default: pix_data <= BLACK;
                    endcase
                end
                else if (in_t_box) begin
                    case (t_char_y)
                        3'd0: pix_data <= T_ROW_0[3'd7 - t_char_x] ? WHITE : BLACK;
                        3'd1: pix_data <= T_ROW_1[3'd7 - t_char_x] ? WHITE : BLACK;
                        3'd2: pix_data <= T_ROW_2[3'd7 - t_char_x] ? WHITE : BLACK;
                        3'd3: pix_data <= T_ROW_3[3'd7 - t_char_x] ? WHITE : BLACK;
                        3'd4: pix_data <= T_ROW_4[3'd7 - t_char_x] ? WHITE : BLACK;
                        3'd5: pix_data <= T_ROW_5[3'd7 - t_char_x] ? WHITE : BLACK;
                        3'd6: pix_data <= T_ROW_6[3'd7 - t_char_x] ? WHITE : BLACK;
                        3'd7: pix_data <= T_ROW_7[3'd7 - t_char_x] ? WHITE : BLACK;
                        default: pix_data <= BLACK;
                    endcase
                end
                else
                    pix_data <= BLACK;
            end


            END: begin
                if (in_e_box) begin
                    case (e_char_y)
                        3'd0: pix_data <= E_ROW_0[3'd7 - e_char_x] ? WHITE : BLACK;
                        3'd1: pix_data <= E_ROW_1[3'd7 - e_char_x] ? WHITE : BLACK;
                        3'd2: pix_data <= E_ROW_2[3'd7 - e_char_x] ? WHITE : BLACK;
                        3'd3: pix_data <= E_ROW_3[3'd7 - e_char_x] ? WHITE : BLACK;
                        3'd4: pix_data <= E_ROW_4[3'd7 - e_char_x] ? WHITE : BLACK;
                        3'd5: pix_data <= E_ROW_5[3'd7 - e_char_x] ? WHITE : BLACK;
                        3'd6: pix_data <= E_ROW_6[3'd7 - e_char_x] ? WHITE : BLACK;
                        3'd7: pix_data <= E_ROW_7[3'd7 - e_char_x] ? WHITE : BLACK;
                        default: pix_data <= BLACK;
                    endcase
                end
                else if (in_n_box) begin
                    case (n_char_y)
                        3'd0: pix_data <= N_ROW_0[3'd7 - n_char_x] ? WHITE : BLACK;
                        3'd1: pix_data <= N_ROW_1[3'd7 - n_char_x] ? WHITE : BLACK;
                        3'd2: pix_data <= N_ROW_2[3'd7 - n_char_x] ? WHITE : BLACK;
                        3'd3: pix_data <= N_ROW_3[3'd7 - n_char_x] ? WHITE : BLACK;
                        3'd4: pix_data <= N_ROW_4[3'd7 - n_char_x] ? WHITE : BLACK;
                        3'd5: pix_data <= N_ROW_5[3'd7 - n_char_x] ? WHITE : BLACK;
                        3'd6: pix_data <= N_ROW_6[3'd7 - n_char_x] ? WHITE : BLACK;
                        3'd7: pix_data <= N_ROW_7[3'd7 - n_char_x] ? WHITE : BLACK;
                        default: pix_data <= BLACK;
                    endcase
                end
                else if (in_d_box) begin
                    case (d_char_y)
                        3'd0: pix_data <= D_ROW_0[3'd7 - d_char_x] ? WHITE : BLACK;
                        3'd1: pix_data <= D_ROW_1[3'd7 - d_char_x] ? WHITE : BLACK;
                        3'd2: pix_data <= D_ROW_2[3'd7 - d_char_x] ? WHITE : BLACK;
                        3'd3: pix_data <= D_ROW_3[3'd7 - d_char_x] ? WHITE : BLACK;
                        3'd4: pix_data <= D_ROW_4[3'd7 - d_char_x] ? WHITE : BLACK;
                        3'd5: pix_data <= D_ROW_5[3'd7 - d_char_x] ? WHITE : BLACK;
                        3'd6: pix_data <= D_ROW_6[3'd7 - d_char_x] ? WHITE : BLACK;
                        3'd7: pix_data <= D_ROW_7[3'd7 - d_char_x] ? WHITE : BLACK;
                        default: pix_data <= BLACK;
                    endcase
                end
                else
                    pix_data <= BLACK;
            end


            default: pix_data <= BLACK;
        endcase
    end
end

endmodule