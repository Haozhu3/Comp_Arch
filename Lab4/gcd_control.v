module gcd_control(done, x_sel, y_sel, x_en, y_en, output_en, go, x_lt_y, x_ne_y, clock, reset);
	output	x_sel, y_sel, x_en, y_en, output_en, done; //xney == x != y
	input	go, x_lt_y, x_ne_y;
	input	clock, reset;

	// IMPLEMENT YOUR STATE MACHINE HERE
	/*wire ds0,ds1,ds2,qs0,qs1,qs2, fake_neq;
	// ds0: 000go 00110 01010 01110
	assign fake_neq = ~qs2 && ~qs1 && qs0;
	assign ds0 = (~qs0 && ~qs1 && ~qs2 && go) || (~qs2 && ~qs1 && qs0 && x_ne_y && ~x_lt_y) || (~qs2 && qs1 && ~qs0 && x_ne_y && ~x_lt_y && x_ne_y) && (~qs2 && qs1 && qs0 && x_ne_y && ~x_lt_y);
	assign ds1 = (~qs2 && ~qs1 && qs0 && x_ne_y) || (~qs2 && qs1 && ~qs0 && x_ne_y) || (~qs2 && qs1 && qs0 && x_ne_y);
	
	// 010ne' 011ne'  
	assign ds2 = (~qs2 && qs1 && ~qs0 && ~x_ne_y) || (~qs2 && qs1 && qs0 && ~x_ne_y) || (qs2 && ~qs1 && ~qs0);
	assign done = qs2; //cr
	assign x_sel = ~(~qs2 && ~qs1 && qs0);
	assign y_sel = ~(~qs2 && ~qs1 && qs0);
	assign output_en = done; 
	assign x_en = (~qs2 && ~qs1 && qs0) || (~qs2 && qs1 && qs0);
	assign y_en = (~qs2 && ~qs1 && qs0) || (~qs2 && qs1 && ~qs0); 
	dffe s2(qs2,ds2,clock,1,reset);
	dffe s1(qs1,ds1,clock,1,reset);
	dffe s0(qs0,ds0,clock,1,reset);
	*/
	wire ds, db, di, ddg, dd, dxg, dx, dfg, df;
	wire qs, qb, qi, qdg, qd, qxg, qx, qfg, qf;
	wire fake_neq;
	
	assign fake_neq = (qs || qi) || x_ne_y;
	assign ds = ~go & (qs) | reset;
	//assign db = go & (qs || df || dx ||)
	assign di = (go && qs) || ((go && (qd || qx || qf)));
	assign ddg = go && (qi || qdg || qxg) && (x_ne_y) && (~x_lt_y) ;
	assign dd = ~go && (x_ne_y) && (~x_lt_y) && (qi || qdg || qxg || qd || qx);
	assign dxg = go && (qi || qdg || qxg) && (x_ne_y) && (x_lt_y);
	assign dx = ~go && (x_ne_y) && (x_lt_y) && (qi || qdg || qxg || qd || qx);
	assign dfg = go && ((qi || qdg || qxg) && (~x_ne_y)|| qfg);
	assign df = ~go && ((qi || qdg || qxg || qx || qd) && (~x_ne_y) || qf);
	
	
	
	
	dffe RSTART(qs,ds,clock,1,reset);
	//dffe BLANK();
	dffe RINIT(qi,di,clock,1,reset);
	dffe RXDAYGO(qdg,ddg,clock,1,reset);
	dffe RXDAYNGO(qd,dd,clock,1,reset);
	dffe RXXIAOYGO(qxg,dxg,clock,1,reset);
	dffe RXXIAOYNGO(qx,dx,clock,1,reset);
	dffe RFIN_GO(qfg,dfg,clock,1,reset);
	dffe RFIN_NGO(qf,df,clock,1,reset);
	
	assign done = qfg || qf || ~fake_neq;
	assign x_sel = ~x_lt_y && x_ne_y;
	assign y_sel = x_lt_y && x_ne_y;
	assign x_en = (~x_lt_y & fake_neq) || qi;
	assign y_en = (x_lt_y & fake_neq) || qi;
	assign output_en = done;
	
	
endmodule //GCD_control
