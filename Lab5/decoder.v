// mips_decode: a decoder for MIPS arithmetic instructions
//
// alu_op      (output) - control signal to be sent to the ALU
// writeenable (output) - should a new value be captured by the register file
// rd_src      (output) - should the destination register be rd (0) or rt (1)
// alu_src2    (output) - should the 2nd ALU source be a register (0) or an immediate (1)
// except      (output) - set to 1 when the opcode/funct combination is unrecognized
// opcode      (input)  - the opcode field from the instruction
// funct       (input)  - the function field from the instruction
//

module mips_decode(alu_op, writeenable, rd_src, alu_src2, except, opcode, funct);
    output [2:0] alu_op;
    output       writeenable, rd_src, alu_src2, except;
    input  [5:0] opcode, funct;

	wire jia,jiai,sub,he,hei,huo,huoi,yh,yhi,yf;
	
	assign jia = (opcode == 6'h00) & (funct == 6'h20); //ADD
	assign jiai = (opcode == 6'h08);
	assign sub = (opcode == 6'h00) & (funct == 6'h22);
	assign he = (opcode == 6'h00) & (funct == 6'h24); // AND
	assign hei = opcode == 6'h0c;
	assign huo = (opcode == 6'h00) & (funct == 6'h25); //OR
	assign huoi = (opcode == 6'h0d);
	assign yh = (opcode == 6'h00) & (funct == 6'h26); //XOR
	assign yhi = opcode == 6'h0e; //XORI
	assign yf =  (opcode == 6'h00) & (funct == 6'h27); //NOR
	
	assign alu_op[0] = sub | huo | yh | huoi | yhi; // sub or xor
	assign alu_op[1] = jia | sub | yf | yh | jiai | yhi; // add sub nor xor
	assign alu_op[2] = he | hei | huo | yf | yh | huoi | yhi ; //and or nor xor
	
	assign rd_src = jiai | hei | huoi | yhi; 
	
	assign alu_src2 = rd_src;
	
	assign writeenable = jia | jiai | sub | he | hei | huo | huoi | yh | yhi | yf;
	
	assign except = ~writeenable; 

endmodule // mips_decode
