module sc2_test;
	reg ain, bin, cin;
	
	wire sout, cout;
	
	sc2_block sc2(sout, cout, ain, bin, cin);
	
   initial begin                             // initial = run at beginning of simulation
                                              // begin/end = associate block with initial
 
       $dumpfile("sc.vcd");                  // name of dump file to create
       $dumpvars(0,sc2_test);                 // record all signals of module "sc_test" and sub-mo
       
        ain = 0; bin = 0; cin = 0; # 10;             // set initial values and wait 10 time units
        ain = 0; bin = 0; cin = 1; # 10;             // change inputs and then wait 10 time units
        ain = 0; bin = 1; cin = 0; # 10;             // as above
        ain = 0; bin = 1; cin = 1; # 10;
        ain = 1; bin = 0; cin = 0; # 10;
        ain = 1; bin = 0; cin = 1; # 10;
        ain = 1; bin = 1; cin = 0; # 10;
        ain = 1; bin = 1; cin = 1; # 10;
 
        $finish;                              // end the simulation
    end                      
    
    initial
        $monitor("At time %2t, ain = %d bin = %d cin = %d sout = %d cout = %d",
                 $time, ain, bin, cin, sout, cout);
	
endmodule // sc2_test
