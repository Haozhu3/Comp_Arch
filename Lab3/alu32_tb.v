module alu32_test;
    reg signed [31:0] A = 0, B = 0;
    reg signed [2:0] control = 0;

    initial begin
        $dumpfile("alu32.vcd");
        $dumpvars(0, alu32_test);

        A = 8; B = 4; control = `ALU_ADD; # 10  // try adding 8 and 4
		A = 2; B = 5; control = `ALU_SUB; # 10// try subtracting 5 from 2
		A = 24; B = -5; control = `ALU_XOR; # 10// try subtracting 5 from 2		
        A = 0; B = 222; control = `ALU_AND; # 10
        A = 65; B = 999; control = `ALU_NOR; # 10
        A = 65; B = 65; control = `ALU_SUB; # 10
        A = 65; B = -65; control = `ALU_ADD; # 10
        A = 32'h7fffffff; B = 1; control = `ALU_ADD; # 10
        A = 32'h80000000; B = 1; control = `ALU_SUB; #10
        // add more test cases here!

         $finish;
    end

    wire signed [31:0] out;
    wire overflow, zero, negative;
    alu32 a(out, overflow, zero, negative, A, B, control);  
    
    
        initial
        $monitor("At time %2t, A = %d B = %d control = %d out = %d overflow = %d zero = %d negative = %d",
                 $time, A, B, control , out, overflow, zero, negative);
endmodule // alu32_test
