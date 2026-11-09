`timescale 1ns/1ns
module lab4_vga (
    input  wire        sys_clk,     
    input  wire        sys_rst_n,   
    input  wire        key_in,      
    output wire        hsync,
    output wire        vsync,
    output wire [15:0] rgb         
);

wire        vga_clk;
wire [9:0]  pix_x;
wire [9:0]  pix_y;
wire [15:0] pix_data;
wire        key_flag;
wire [1:0]  pic_state;

pll pll_inst (
    .sys_clk    (sys_clk),
    .sys_rst_n  (sys_rst_n),
    .vga_clk    (vga_clk)
);

re_button re_button_inst (
    .vga_clk    (vga_clk),
    .sys_rst_n  (sys_rst_n),
    .key_in     (key_in),
    .key_flag   (key_flag)
);

fsm fsm_inst (
    .vga_clk    (vga_clk),
    .sys_rst_n  (sys_rst_n),
    .key_flag   (key_flag),
    .pic_state  (pic_state)
);

vga_pic vga_pic_inst (
    .vga_clk    (vga_clk),
    .sys_rst_n  (sys_rst_n),
    .pix_x      (pix_x),
    .pix_y      (pix_y),
    .pic_state  (pic_state),
    .pix_data   (pix_data)
);

vga_ctrl vga_ctrl_inst (
    .vga_clk    (vga_clk),
    .sys_rst_n  (sys_rst_n),
    .pix_data   (pix_data),
    .pix_x      (pix_x),
    .pix_y      (pix_y),
    .hsync      (hsync),
    .vsync      (vsync),
    .rgb        (rgb)
);

endmodule