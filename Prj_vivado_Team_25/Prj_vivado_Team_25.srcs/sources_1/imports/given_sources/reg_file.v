module reg_file(clk, RegWrite, RN1, RN2, WN, RD1, RD2, WD);
  input clk;
  input RegWrite;
  input [4:0] RN1, RN2, WN;
  input [31:0] WD;
  output [31:0] RD1, RD2;

  reg [31:0] RD1, RD2;
  reg [31:0] file_array [31:1];
  wire [31:0] v0 = file_array[2];
  wire [31:0] a0 = file_array[4];
  wire [31:0] t0 = file_array[8];
  wire [31:0] sp = file_array[29];
  wire [31:0] ra = file_array[31];
  
  initial
  begin
	file_array[4] = 5;
	file_array[29] = 32'h80000000;
  end

  always @(RN1 or file_array[RN1])
  begin   
    if (RN1 == 0) RD1 = 32'd0;
    else RD1 = file_array[RN1];
    $display($time, " reg_file[%d] => %d (Port 1)", RN1, RD1);
  end

  always @(RN2 or file_array[RN2])
  begin
    if (RN2 == 0) RD2 = 32'd0;
    else RD2 = file_array[RN2];
    $display($time, " reg_file[%d] => %d (Port 2)", RN2, RD2);
  end

  always @(posedge clk) 
    if (RegWrite && (WN != 0))
    begin
		file_array[WN] <= WD;
		$display($time, " reg_file[%d] <= %d (Write)", WN, WD);
    end
endmodule

