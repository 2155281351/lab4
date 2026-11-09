`timescale 1ns/1ns
module re_button (
    input  wire vga_clk,       
    input  wire sys_rst_n,     
    input  wire key_in,       
    output wire key_flag     
);

localparam CNT_20MS_MAX = 20'd500_000;

reg key_sync0, key_sync1;
always @(posedge vga_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        key_sync0 <= 1'b1;
        key_sync1 <= 1'b1;
    end else begin
        key_sync0 <= key_in;
        key_sync1 <= key_sync0;
    end
end

reg [19:0] cnt_press_20ms;
always @(posedge vga_clk or negedge sys_rst_n) begin
    if (!sys_rst_n)
        cnt_press_20ms <= 20'd0;
    else if (key_sync1)                      
        cnt_press_20ms <= 20'd0;
    else if (cnt_press_20ms == CNT_20MS_MAX - 1'd1)
        cnt_press_20ms <= cnt_press_20ms;     
    else
        cnt_press_20ms <= cnt_press_20ms + 1'd1;
end

reg [19:0] cnt_release_20ms;
always @(posedge vga_clk or negedge sys_rst_n) begin
    if (!sys_rst_n)
        cnt_release_20ms <= 20'd0;
    else if (!key_sync1)                     
        cnt_release_20ms <= 20'd0;
    else if (cnt_release_20ms == CNT_20MS_MAX - 1'd1)
        cnt_release_20ms <= cnt_release_20ms; 
    else
        cnt_release_20ms <= cnt_release_20ms + 1'd1;
end

reg key_up_flag;
always @(posedge vga_clk or negedge sys_rst_n) begin
    if (!sys_rst_n)
        key_up_flag <= 1'b1;
    else if (cnt_press_20ms >= CNT_20MS_MAX - 1'd1)
        key_up_flag <= 1'b0;                
    else if (cnt_release_20ms >= CNT_20MS_MAX - 1'd1)
        key_up_flag <= 1'b1;                 
end


reg wait_release;
always @(posedge vga_clk or negedge sys_rst_n) begin
    if (!sys_rst_n)
        wait_release <= 1'b1;
    else if (cnt_release_20ms >= CNT_20MS_MAX - 1'd1)
        wait_release <= 1'b0;
end


reg key_up_prev;
always @(posedge vga_clk or negedge sys_rst_n) begin
    if (!sys_rst_n)
        key_up_prev <= 1'b1;
    else
        key_up_prev <= key_up_flag;
end

assign key_flag = (key_up_prev == 1'b1) && (key_up_flag == 1'b0) && (~wait_release);

endmodule