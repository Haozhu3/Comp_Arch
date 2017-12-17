// mips_decode: a decoder for MIPS arithmetic instructions
//
// alu_op       (output) - control signal to be sent to the ALU
// writeenable  (output) - should a new value be captured by the register file
// rd_src       (output) - should the destination register be rd (0) or rt (1)
// alu_src2     (output) - should the 2nd ALU source be a register (0) or an immediate (1)
// except       (output) - set to 1 when we don't recognize an opdcode & funct combination
// control_type (output) - 00 = fallthrough, 01 = branch_target, 10 = jump_target, 11 = jump_register 
// mem_read     (output) - the register value written is coming from the memory
// word_we      (output) - we're writing a word's worth of data
// byte_we      (output) - we're only writing a byte's worth of data
// byte_load    (output) - we're doing a byte load
// lui          (output) - the instruction is a lui
// slt          (output) - the instruction is an slt
// addm         (output) - the instruction is an addm
// opcode        (input) - the opcode field from the instruction
// funct         (input) - the function field from the instruction
// zero          (input) - from the ALU
//

module mips_decode(alu_op, writeenable, rd_src, alu_src2, except, control_type,
                   mem_read, word_we, byte_we, byte_load, lui, slt, addm,
                   opcode, funct, zero);
    output [2:0] alu_op;
    output       writeenable, rd_src, alu_src2, except;
    output [1:0] control_type;
    output       mem_read, word_we, byte_we, byte_load, lui, slt, addm;
    input  [5:0] opcode, funct;
    input        zero;
    
    wire jia,jiai,sub,he,hei,huo,huoi,yh,yhi,yf,bne,beq,j,jr,lw,lbu,sw,sb;
	
	assign jia = (opcode == 6'h00) & (funct == 6'h20); //ADD
	assign jiai = (opcode == 6'h08); // ADDI
	assign sub = (opcode == 6'h00) & (funct == 6'h22); // SUB
	assign he = (opcode == 6'h00) & (funct == 6'h24); // AND
	assign hei = opcode == 6'h0c; // ANDI
	assign huo = (opcode == 6'h00) & (funct == 6'h25); //OR
	assign huoi = (opcode == 6'h0d); // ORI
	assign yh = (opcode == 6'h00) & (funct == 6'h26); //XOR
	assign yhi = opcode == 6'h0e; //XORI
	assign yf =  (opcode == 6'h00) & (funct == 6'h27); //NOR
	
	assign bne = (opcode == `OP_BNE);
	assign beq = (opcode == `OP_BEQ);
	assign j = (opcode == `OP_J);
	assign jr = (opcode == `OP_OTHER0) & (funct == `OP0_JR);
	assign lw = (opcode == `OP_LW);
	assign lbu = (opcode ==`OP_LBU);
	assign sw = (opcode == `OP_SW);
	assign sb = (opcode == `OP_SB);
	assign lui = (opcode == `OP_LUI);
	assign slt = (opcode == `OP_OTHER0) & (funct == `OP0_SLT);
	assign addm = (opcode == `OP_OTHER0) & (funct == `OP0_ADDM);
	
	assign rd_src = jiai | hei | huoi | yhi | lui | lw | lbu; // Rt is dest
	assign alu_src2 =  jiai | hei | huoi | yhi | lw | lbu | sw | sb; // sign extended 
	assign writeenable = jia|jiai|sub|he|hei|huo|huoi|yh|yhi|yf|lui|slt|lw|lbu|addm; // write into Register
	
	assign alu_op[0] = sub | huo | yh | huoi | yhi | slt | beq | bne; // sub or xor slt beq bne
	assign alu_op[1] = jia | sub | yf | yh | jiai | yhi | slt | lw | lbu | sw | sb | beq | bne | addm; // add sub nor xor
	assign alu_op[2] = he | hei | huo | yf | yh | huoi | yhi ; //and or nor xor
	
	assign control_type[0] = (beq & zero) | jr | (bne & ~zero); // jr eq neq
	assign control_type[1] = jr | j;
	assign mem_read = lw | lbu | addm;
	assign word_we = sw;
	assign byte_we = sb;
	assign byte_load = lbu;
    assign except = ~(jia|jiai|sub|he|hei|huo|huoi|yh|yhi|yf|bne|beq|j|jr|lui|slt|lw|lbu|sw|sb|addm);	
	
endmodule // mips_decode
