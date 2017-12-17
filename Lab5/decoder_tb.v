module decoder_test;
    reg [5:0] opcode, funct;

    initial begin
        $dumpfile("decoder.vcd");
        $dumpvars(0, decoder_test);

             opcode = `OP_OTHER0; funct = `OP0_ADD; // try addition
        # 10 opcode = `OP_OTHER0; funct = `OP0_SUB; // try subtraction
        // add more tests here!
		# 20 
        $finish;
    end




    // use gtkwave to test correctness
    wire [2:0] alu_op;
    wire       writeenable, rd_src, alu_src2, except;
    mips_decode decoder(alu_op, writeenable, rd_src, alu_src2, except,
                        opcode, funct);
                        
                        initial
        $monitor("At time %2t, opcode = %d funct = %d alu_op = %d",
                 $time, opcode, funct, alu_op); 
                        
                        
endmodule // decoder_test
