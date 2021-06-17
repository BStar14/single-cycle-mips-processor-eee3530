`timescale 1ns/10ps

module tb_single_MIPS;
    
    reg clk;
    reg reset;
    
    mips_single MIPS (clk, reset);
    
    initial begin
        forever #2 clk <= ~clk;
    end
    
    initial begin
        clk <= 1'b0; reset <= 1'b0;
        #2 reset <= 1'b1;
        #2 reset <= 1'b0;
        #222 $stop;
    end
    
endmodule
