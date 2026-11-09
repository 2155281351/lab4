`timescale 1ns/1ns
module fsm (
    input  wire       vga_clk,
    input  wire       sys_rst_n,
    input  wire       key_flag,     
    output reg  [1:0] pic_state
);

localparam BARS = 2'b00;
localparam MUST = 2'b01;
localparam END  = 2'b10;

always @(posedge vga_clk or negedge sys_rst_n) begin
    if (!sys_rst_n)
        pic_state <= BARS;
    else if (key_flag) begin
        case (pic_state)
            BARS: pic_state <= MUST;
            MUST: pic_state <= END;
            END : pic_state <= BARS;
            default: pic_state <= BARS;
        endcase
    end
end

endmodule