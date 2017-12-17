// Design a circuit that divides a two 2-bit unsigned binary number
// ('a') by another 2-bit unsigned binary number ('b') to produce a
// 2-bit output ('out').  When dividing by 0, set the output to all
// ones.

module udiv(out, a, b);
   output [1:0] out;
   input  [1:0]	a, b;

	assign out[1] = (~b[0] & ~b[1]) | (a[1] & ~a[0] & ~b[1]) | (a[1] & a[0] & ~b[1]);
	assign out[0] = (~b[0] & ~b[1]) | (a[1] & a[0]) | (a[0] & ~a[1] & b[0] & ~b[1]) | (~a[0] & a[1] & ~b[0] & b[1]);
   
endmodule // udiv

