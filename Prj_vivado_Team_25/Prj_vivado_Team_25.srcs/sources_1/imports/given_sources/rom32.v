module rom32(address, data_out);
  input  [31:0] address;
  output [31:0] data_out;
  reg    [31:0] data_out;

  parameter BASE_ADDRESS = 24'h400000; // address that applies to this memory

  wire [5:0] mem_offset;
  wire address_select;

  assign mem_offset = address[7:2];  // drop 2 LSBs to get word offset

  assign address_select = (address[31:8] == BASE_ADDRESS);  // address decoding

  always @(address_select or mem_offset)
  begin
    if ((address % 4) != 0) $display($time, " rom32 error: unaligned address %d", address);
    if (address_select == 1)
    begin
      case (mem_offset) 
          5'd0 : data_out = { 6'd0, 5'd0, 5'd4, 5'd8, 5'd0, 6'd42 };    // slt $t0, $zero, $a0
          5'd1 : data_out = { 6'd4, 5'd8, 5'd0, 16'd4 };                // beq $t0, $zero, exit (= +4)
          5'd2 : data_out = { 6'd8, 5'd0, 5'd8, 16'd6 };                // addi $t0, $zero, 6
          5'd3 : data_out = { 6'd0, 5'd4, 5'd8, 5'd8, 5'd0, 6'd42 };    // slt $t0, $a0, $t0
          5'd4 : data_out = { 6'd4, 5'd8, 5'd0, 16'd1 };                // beq $t0, $zero, exit (= +1)
          5'd5 : data_out = { 6'd3, 26'd7 };                            // jal Hanoi_tower (= 0x4000_001c)
          5'd6 : data_out = { 6'd2, 26'd6 };                            // j exit (= 0x4000_0018)
          5'd7 : data_out = { 6'd8, 5'd0, 5'd8, 16'd1 };                // addi $t0, $zero, 1
          5'd8 : data_out = { 6'd4, 5'd4, 5'd8, 16'd9 };               // beq $a0, $t0, skip (= +9)
          5'd9 : data_out = { 6'd8, 5'd4, 5'd4, -16'd1 };               // addi $a0, $a0, -1
          5'd10 : data_out = { 6'd8, 5'd29, 5'd29, -16'd4 };            // addi $sp, $sp, -4
          5'd11 : data_out = { 6'd43, 5'd29, 5'd31, 16'd0 };            // sw $ra, 0($sp)
          5'd12 : data_out = { 6'd3, 26'd7 };                           // jal Hanoi_tower (= 0x4000_001c)
          5'd13 : data_out = { 6'd0, 5'd2, 5'd2, 5'd2, 5'd0, 6'd32 };   // add $v0, $v0, $v0
          5'd14 : data_out = { 6'd8, 5'd2, 5'd2, 16'd1 };               // addi $v0, $v0, 1
          5'd15 : data_out = { 6'd35, 5'd29, 5'd31, 16'd0 };            // lw $ra, 0($sp)
          5'd16 : data_out = { 6'd8, 5'd29, 5'd29, 16'd4 };             // addi $sp, $sp, 4
          5'd17 : data_out = { 6'd0, 5'd31, 5'd0, 5'd0, 5'd0, 6'd8 };   // jr $ra
          5'd18 : data_out = { 6'd8, 5'd0, 5'd2, 16'd1 };               // addi $v0, $zero, 1
          5'd19 : data_out = { 6'd0, 5'd31, 5'd0, 5'd0, 5'd0, 6'd8 };   // jr $ra
          default data_out = 32'hxxxx;
      endcase
      $display($time, " reading data: rom32[%h] => %h", address, data_out);
    end
  end 
endmodule
