module alu1_test;
    // exhaustively test your 1-bit ALU by adapting mux4_tb.v
    reg A,B,carryin;
    reg [2:0] control;
    
    wire out,carryout;
    
    alu1 test(out,carryout,A,B,carryin,control);
    	initial begin
    $dumpfile("alu1.vcd");                  // name of dump file to create
       $dumpvars(0,alu1_test);  
    	
        A = 0; B = 0;carryin = 0;   control = 010; # 10; 
        A = 0; B = 1;carryin = 0;   control = 010; # 10; 
        A = 1; B = 0;carryin = 0;   control = 010; # 10; 
        A = 1; B = 1;carryin = 0;   control = 010; # 10; 
        A = 0; B = 0;carryin = 0;   control = 011; # 10; 
        A = 0; B = 1;carryin = 0;   control = 011; # 10; 
        A = 1; B = 0;carryin = 0;   control = 011; # 10; 
        A = 1; B = 1;carryin = 0;   control = 011; # 10;
        A = 0; B = 0;carryin = 0;   control = 100; # 10; 
        A = 0; B = 1;carryin = 0;   control = 100; # 10; 
        A = 1; B = 0;carryin = 0;   control = 100; # 10; 
        A = 1; B = 1;carryin = 0;   control = 100; # 10;
        A = 0; B = 0;carryin = 0;   control = 101; # 10; 
        A = 0; B = 1;carryin = 0;   control = 101; # 10; 
        A = 1; B = 0;carryin = 0;   control = 101; # 10; 
        A = 1; B = 1;carryin = 0;   control = 101; # 10;
        A = 0; B = 0;carryin = 0;   control = 110; # 10; 
        A = 0; B = 1;carryin = 0;   control = 110; # 10; 
        A = 1; B = 0;carryin = 0;   control = 110; # 10; 
        A = 1; B = 1;carryin = 0;   control = 110; # 10;
        A = 0; B = 0;carryin = 0;   control = 111; # 10; 
        A = 0; B = 1;carryin = 0;   control = 111; # 10; 
        A = 1; B = 0;carryin = 0;   control = 111; # 10; 
        A = 1; B = 1;carryin = 0;   control = 111; # 10;                                
        $finish;                              // end the simulation
    end                      
    
    initial
        $monitor("At time %2t, A = %d B = %d control = %d out = %d cout = %d",
                 $time, A, B, control , out, carryout);
endmodule
