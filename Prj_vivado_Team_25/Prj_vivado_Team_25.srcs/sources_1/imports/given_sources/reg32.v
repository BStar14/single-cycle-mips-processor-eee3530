// Title         : 32-Bit Register with Synchronous Reset
// Project       : ECE 313 - Computer Organization
//-----------------------------------------------------------------------------
// File          : reg32.v
// Author        : John Nestor  <nestorj@lafayette.edu>
// Organization  : Lafayette College
// 
// Created       : October 2002
// Last modified : 7 January 2005
//-----------------------------------------------------------------------------
// Description :
//   Simple 32-bit register with synchronous reset  used in the implementations of
//   the MIPS processor subset described in Ch. 5-6 of "Computer Organization and Design,
//   3rd ed." by David Patterson & John Hennessey, Morgan Kaufmann, 2004 (COD3e).  
//
//-----------------------------------------------------------------------------

module reg32 (clk, reset, d_in, d_out);
    input       	clk, reset;
    input	[31:0]	d_in;
    output 	[31:0] 	d_out;
    reg 	[31:0]	 d_out;
    
    wire [7:0] pc_in = d_in;
    wire [7:0] pc_out = d_out;
   
    always @(posedge clk)
    begin
        if (reset) d_out <= 32'h40000000;
        else d_out <= d_in;
    end

endmodule
	
