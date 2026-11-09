`timescale 1ns/1ns

module lab4_vga_tb;

reg  sys_clk;
reg  sys_rst_n;
reg  key_in;

wire        hsync;
wire        vsync;
wire [15:0] rgb;

wire [1:0]  pic_state    = dut.fsm_inst.pic_state;
wire        key_flag     = dut.key_flag;
wire        key_up_flag  = dut.re_button_inst.key_up_flag;
wire        wait_release = dut.re_button_inst.wait_release;

lab4_vga dut (
    .sys_clk   (sys_clk),
    .sys_rst_n (sys_rst_n),
    .key_in    (key_in),
    .hsync     (hsync),
    .vsync     (vsync),
    .rgb       (rgb)
);

initial sys_clk = 1'b0;
always #10 sys_clk = ~sys_clk;

localparam BARS = 2'b00;
localparam MUST = 2'b01;
localparam END  = 2'b10;

integer errors = 0;

task check_state;
    input [1:0]   expected;
    input [127:0] tag;
    begin
        if (pic_state !== expected) begin
            $display("[FAIL] %0s : pic_state=%b, expect=%b", tag, pic_state, expected);
            errors = errors + 1;
        end
        else
            $display("[PASS] %0s : pic_state=%b", tag, pic_state);
    end
endtask


task click;
    begin
        key_in = 1'b0; #30_000_000;
        key_in = 1'b1; #30_000_000;
    end
endtask

initial begin
    sys_rst_n = 1'b0;
    key_in    = 1'b1;

    $dumpfile("lab4_vga_tb.vcd");

    $dumpvars(1, sys_rst_n);
    $dumpvars(1, key_in);
    $dumpvars(1, key_up_flag);
    $dumpvars(1, key_flag);
    $dumpvars(1, wait_release);
    $dumpvars(1, pic_state);

    
    #200;
    sys_rst_n = 1'b1;
    #25_000_000;                      
    check_state(BARS, "after reset");

   
    click(); check_state(MUST, "click 1: BARS->MUST");
    click(); check_state(END,  "click 2: MUST->END");
    click(); check_state(BARS, "click 3: END->BARS");

 
    key_in = 1'b0; #1_000_000;
    key_in = 1'b1; #500_000;
    key_in = 1'b0; #800_000;
    key_in = 1'b1; #600_000;
  
    key_in = 1'b0; #30_000_000;

    key_in = 1'b1; #30_000_000;
    check_state(MUST, "bouncy click: exactly one");

   
    key_in = 1'b0; #100_000_000;
    key_in = 1'b1; #30_000_000;
    check_state(END, "long press 100ms: exactly one");

    
    sys_rst_n = 1'b0; #1_000_000;
    sys_rst_n = 1'b1;
    check_state(BARS, "reset from END");
    #25_000_000;

    
    key_in = 1'b0; #30_000_000;      
    sys_rst_n = 1'b0; #1_000_000;      
    sys_rst_n = 1'b1; #30_000_000;    
    check_state(BARS, "reset while held: stay BARS");

  
    key_in = 1'b1; #30_000_000;
    check_state(BARS, "release after reset-while-held");

    click(); check_state(MUST, "normal click after recovery");

    if (errors == 0)
        $display("\n=== ALL TESTS PASSED ===");
    else
        $display("\n=== %0d TEST(S) FAILED ===", errors);

    $finish;
end

endmodule