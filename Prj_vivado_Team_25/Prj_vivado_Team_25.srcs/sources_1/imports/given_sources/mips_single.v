module mips_single(clk, reset);
    input clk, reset;

    // instruction bus
    wire [31:0] instr;

    // break out important fields from instruction
    wire [5:0] opcode, funct;
    wire [4:0] rs, rt, rd, shamt;
    wire [15:0] immed;
    wire [31:0] extend_immed, b_offset, jump_address;
    wire [25:0] jumpoffset;
    wire [27:0] jump_shifted;

    assign opcode = instr[31:26];
    assign rs = instr[25:21];
    assign rt = instr[20:16];
    assign rd = instr[15:11];
    assign shamt = instr[10:6];
    assign funct = instr[5:0];
    assign immed = instr[15:0];
    assign jumpoffset = instr[25:0];

    // sign-extender
    assign extend_immed = { {16{immed[15]}}, immed };
    
    // branch offset shifter
    assign b_offset = extend_immed << 2;
    
    // datapath signals
    wire [4:0] rfile_wn, wn_result;
    wire [3:0] pseudo;
    wire [31:0] rfile_rd1, rfile_rd2, rfile_wd, alu_b, alu_out, b_tgt, pc_next, j_result, b_result,
                pc, pc_incr, dmem_result, dmem_rdata;
    
    
    // control signals

    wire RegWrite, Branch, PCSrc, RegDst, MemtoReg, MemRead, MemWrite, ALUSrc, Zero, Jump, Jr, Jal1, Jal2;
    wire [1:0] ALUOp;
    wire [2:0] Operation;

    // module instantiations

    reg32		PC(clk, reset, pc_next, pc);

    add32 		PCADD(pc, 32'd4, pc_incr);

    add32 		BRADD(pc_incr, b_offset, b_tgt);

    reg_file	RFILE(clk, RegWrite, rs, rt, rfile_wn, rfile_rd1, rfile_rd2, rfile_wd); 

    alu 		ALU(Operation, rfile_rd1, alu_b, alu_out, Zero);

    rom32 		IMEM(pc, instr);

    mem32 		DMEM(clk, MemRead, MemWrite, alu_out, rfile_rd2, dmem_rdata);

    and  		BR_AND(PCSrc, Branch, Zero);

    mux2 #(5) 	RFMUX(RegDst, rt, rd, wn_result);

    mux2 #(32)	PCMUX(PCSrc, pc_incr, b_tgt, b_result);

    mux2 #(32) 	ALUMUX(ALUSrc, rfile_rd2, extend_immed, alu_b);

    mux2 #(32)	WRMUX(MemtoReg, alu_out, dmem_rdata, dmem_result);
    
    mux2 #(32)	JMUX(Jump, b_result, jump_address, j_result); //jr instruction mux 추가
    
    mux2 #(32)	JRMUX(Jr, j_result, rfile_rd1, pc_next); //jr instruction mux 추가
    
    mux2 #(32)	JALMUX(Jal1, dmem_result, pc_incr, rfile_wd); //jal instruction mux 추가

    mux2 #(5)	JALMUX2(Jal2, wn_result, 5'd31, rfile_wn); //jal instruction mux 추가


    control_single CTL(.opcode(opcode), .funct(funct), .RegDst(RegDst), .ALUSrc(ALUSrc), .MemtoReg(MemtoReg), 
                       .RegWrite(RegWrite), .MemRead(MemRead), .MemWrite(MemWrite), .Branch(Branch), 
                       .ALUOp(ALUOp), .Jump(Jump), .Jr(Jr), .Jal1(Jal1), .Jal2(Jal2));

    alu_ctl 	ALUCTL(ALUOp, funct, Operation);
   
     // jump address
    assign pseudo = pc_incr[31:28];
    assign jump_shifted = jumpoffset << 2;
    assign jump_address = { pseudo , jump_shifted};
    
endmodule
