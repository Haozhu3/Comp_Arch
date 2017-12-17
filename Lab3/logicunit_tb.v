module logicunit_test;
    // exhaustively test your logic unit by adapting mux4_tb.v
    reg A,B;
    reg [1:0] control;
    
    wire out;
    
    logicunit test(out,A,B,control);
      initial begin                             // initial = run at beginning of simulation
                                              // begin/end = associate block with initial
 
       $dumpfile("logicunit.vcd");                  // name of dump file to create
       $dumpvars(0,logicunit_test);                 // record all signals of module "sc_test" and sub-mo
       
        A = 0; B = 0; control = 00; # 10;             // set initial values and wait 10 time units
        A = 0; B = 1; control = 00; # 10; 
        A = 1; B = 0; control = 00; # 10; 
        A = 1; B = 1; control = 00; # 10; 
        A = 0; B = 0; control = 01; # 10; 
        A = 0; B = 1; control = 01; # 10; 
        A = 1; B = 0; control = 01; # 10; 
        A = 1; B = 1; control = 01; # 10; 
        A = 0; B = 0; control = 10; # 10; 
        A = 0; B = 1; control = 10; # 10; 
        A = 1; B = 0; control = 10; # 10; 
        A = 1; B = 1; control = 10; # 10; 
        A = 0; B = 0; control = 11; # 10; 
        A = 0; B = 1; control = 11; # 10; 
        A = 1; B = 0; control = 11; # 10; 
        A = 1; B = 1; control = 11; # 10;                                                                 
 
        $finish;                              // end the simulation
    end                      
    
    initial
        $monitor("At time %2t, A = %d B = %d control = %d out = %d",
                 $time, A, B, control , out);
    
endmodule // logicunit_test
