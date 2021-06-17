//-----------------------------------------------------------------------------
// Title         : MIPS Single-Cycle Control Unit
// Project       : ECE 313 - Computer Organization
//-----------------------------------------------------------------------------
// File          : control_single.v
// Author        : John Nestor  <nestorj@lafayette.edu>
// Organization  : Lafayette College
// 
// Created       : October 2002
// Last modified : 7 January 2005
//-----------------------------------------------------------------------------
// Description :
//   Control unit for the MIPS "Single Cycle" processor implementation described
//   Section 5.4 of "Computer Organization and Design, 3rd ed."
//   by David Patterson & John Hennessey, Morgan Kaufmann, 2004 (COD3e).  
//
//   It implements the function specified in Figure 5.18 on p. 308 of COD3e.
//
//-----------------------------------------------------------------------------

module control_single(opcode, funct,  RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp, Jump, Jr, Jal1, Jal2);
    input [5:0] opcode, funct;
    output RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, Jump, Jr, Jal1, Jal2;
    output [1:0] ALUOp;
    reg    RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, Jump, Jr, Jal1, Jal2;
    reg    [1:0] ALUOp;

    parameter R_FORMAT = 6'd0;
    parameter ADDI = 6'd8;
    parameter LW = 6'd35;
    parameter SW = 6'd43;
    parameter BEQ = 6'd4;
    parameter JUMP = 6'd2;
    parameter JAL = 6'd3;

    always @(opcode or funct)
    begin
        case (opcode)
          R_FORMAT : 
          begin
            if (funct == 6'd8)
            begin
              RegDst=1'bx; ALUSrc=1'bx; MemtoReg=1'bx; RegWrite=1'b0; MemRead=1'b0; 
              MemWrite=1'b0; Branch=1'b0; ALUOp = 2'bxx; Jump=1'b0; Jr=1'b1; Jal1=1'b0; Jal2=1'b0;
            end
            else
            begin
              RegDst=1'b1; ALUSrc=1'b0; MemtoReg=1'b0; RegWrite=1'b1; MemRead=1'b0; 
              MemWrite=1'b0; Branch=1'b0; ALUOp = 2'b10; Jump=1'b0; Jr=1'b0; Jal1=1'b0; Jal2=1'b0;
            end
          end
          LW :
          begin
              RegDst=1'b0; ALUSrc=1'b1; MemtoReg=1'b1; RegWrite=1'b1; MemRead=1'b1; 
              MemWrite=1'b0; Branch=1'b0; ALUOp = 2'b00; Jump=1'b0; Jr=1'b0; Jal1=1'b0; Jal2=1'b0;
          end
          SW :
          begin
              RegDst=1'bx; ALUSrc=1'b1; MemtoReg=1'bx; RegWrite=1'b0; MemRead=1'b0; 
              MemWrite=1'b1; Branch=1'b0; ALUOp = 2'b00; Jump=1'b0; Jr=1'b0; Jal1=1'b0; Jal2=1'b0;
          end
          BEQ :
          begin
              RegDst=1'bx; ALUSrc=1'b0; MemtoReg=1'bx; RegWrite=1'b0; MemRead=1'b0; 
              MemWrite=1'b0; Branch=1'b1; ALUOp = 2'b01; Jump=1'b0; Jr=1'b0; Jal1=1'b0; Jal2=1'b0;
          end
          JUMP :
          begin
              RegDst=1'bx; ALUSrc=1'bx; MemtoReg=1'bx; RegWrite=1'b0; MemRead=1'b0; 
              MemWrite=1'b0; Branch=1'b0; ALUOp = 2'bxx; Jump=1'b1; Jr=1'b0; Jal1=1'b0; Jal2=1'b0;
          end
          JAL :
          begin
              RegDst=1'bx; ALUSrc=1'bx; MemtoReg=1'bx; RegWrite=1'b1; MemRead=1'b0; 
              MemWrite=1'b0; Branch=1'b0; ALUOp = 2'bxx; Jump=1'b1; Jr=1'b0; Jal1=1'b1; Jal2=1'b1;
          end
          ADDI :
          begin
              RegDst=1'b0; ALUSrc=1'b1; MemtoReg=1'b0; RegWrite=1'b1; MemRead=1'b0; 
              MemWrite=1'b0; Branch=1'b0; ALUOp = 2'b00; Jump=1'b0; Jr=1'b0; Jal1=1'b0; Jal2=1'b0;
          end
          default
          begin
              $display("control_single unimplemented opcode %d", opcode);
              RegDst=1'bx; ALUSrc=1'bx; MemtoReg=1'bx; RegWrite=1'bx; MemRead=1'bx; 
              MemWrite=1'bx; Branch=1'bx; ALUOp = 2'bxx;
          end

        endcase
    end
endmodule
