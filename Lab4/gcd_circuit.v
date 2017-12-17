// GCD datapath
module gcd_circuit(out, x_lt_y, x_ne_y, X, Y, x_sel, y_sel, x_en, y_en, output_en, clock, reset);
	output  [31:0] out;
	output  x_lt_y, x_ne_y;
	input	[31:0]	X, Y;
	input   x_sel, y_sel, x_en, y_en, output_en, clock, reset;

	wire [31:0] muxleft, muxright,xq,yq,subl,subr;
    // IMPLEMENT gcd_circuit HERE
	mux2v mleft(muxleft,X,subl,x_sel);
	mux2v mright(muxright,Y,subr,y_sel);
	register rtpx(xq,muxleft,clock,x_en,reset);
	register rtpy(yq,muxright,clock,y_en,reset);
	subtractor sl(subl,xq,yq);
	subtractor sr(subr,yq,xq);
	comparator comp(x_lt_y,x_ne_y,xq,yq);
	register outreg(out,xq,clock,output_en,reset);
	
endmodule // gcd_circuit
