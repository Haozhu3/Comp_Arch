module keypad(valid, number, a, b, c, d, e, f, g);
   output 	valid;
   output [3:0] number;
   input 	a, b, c, d, e, f, g;
   wire bf,cf,ae,be,ce,af,bd,cd,ad,ag,cg,ncg,nag,vv;
   
   or valid_or(valid,a,b,c,d,e,f);
   
   
   and a1(bf,b,f);
   and a2(cf,c,f);
   and a3(ae,a,e);
   and a4(be,b,e);
   and a5(ce,c,e);
   and a6(af,a,f);
   and a7(bd,b,d);
   and a8(cd,c,d);
   and a9(ad,a,d);
   
   not not1(nag,ag);
   not not2(ncg,cg);
   
   
   or n0(number[0],ad,cd,be,af,cf);
   or n1(number[1],bd,cd,ce,af);
   or n2(number[2],ae,be,ce,af);
   or n3(number[3],bf,cf);
   
   

endmodule // keypad
