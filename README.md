# EIE330 Lab 4: VGA display selection

The active-low button cycles through BARS, MUST and END. Active-low reset selects BARS and waits for a debounced release before accepting another press.

- `rtl/`: Verilog sources, RTL diagrams and the VGA simulator wrapper.
- `sim/`: integration testbench and original VCD.
- `r4_pic/`: syntax, synthesis and simulation evidence.

Run the supplied integration test with Icarus Verilog from the repository root:

```sh
iverilog -g2012 -Wall -s lab4_vga_tb -o /tmp/lab4_vga_sim rtl/*.v sim/lab4_vga_tb.v
(cd /tmp && vvp ./lab4_vga_sim)
```

[Implementation video by the uploader](https://b23.tv/EGB755i)
