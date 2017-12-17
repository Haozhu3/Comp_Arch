// register: A register which may be reset to an arbirary value
//
// q      (output) - Current value of register
// d      (input)  - Next value of register
// clk    (input)  - Clock (positive edge-sensitive)
// enable (input)  - Load new value? (yes = 1, no = 0)
// reset  (input)  - Asynchronous reset    (reset = 1)
//
module register(q, d, clk, enable, reset);

    parameter
        width = 32,
        reset_value = 0;
 
    output [(width-1):0] q;
    reg    [(width-1):0] q;
    input  [(width-1):0] d;
    input                clk, enable, reset;
 
    always@(reset)
      if (reset == 1'b1)
        q <= reset_value;
 
    always@(posedge clk)
      if ((reset == 1'b0) && (enable == 1'b1))
        q <= d;

endmodule // register

module decoder2 (out, in, enable);
    input     in;
    input     enable;
    output [1:0] out;
 
    and a0(out[0], enable, ~in);
    and a1(out[1], enable, in);
endmodule // decoder2

module decoder4 (out, in, enable);
    input [1:0]    in;
    input     enable;
    output [3:0]   out;
    wire [1:0]    w_enable;
 
    decoder2 d0(w_enable[1:0], in[1], enable);
    decoder2 d1(out[1:0], in[0], w_enable[0]);
    decoder2 d2(out[3:2], in[0], w_enable[1]);

    
endmodule // decoder4

module decoder8 (out, in, enable);
    input [2:0]    in;
    input     enable;
    output [7:0]   out;
    wire [1:0]    w_enable;
 
    // implement using decoder2's and decoder4's
    decoder2 d2_0(w_enable[1:0], in[2], enable);
    decoder4 d4_0(out[3:0], in[1:0], w_enable[0]);
    decoder4 d4_1(out[7:4], in[1:0], w_enable[1]);

    
 
endmodule // decoder8

module decoder16 (out, in, enable);
    input [3:0]    in;
    input     enable;
    output [15:0]  out;
    wire [1:0]    w_enable;
 
  decoder2 d2_0(w_enable[1:0], in[3], enable);
  decoder8 d8_0(out[7:0], in[2:0], w_enable[0]);
  decoder8 d8_1(out[15:8], in[2:0], w_enable[1]);

    // implement using decoder2's and decoder8's
 
endmodule // decoder16

module decoder32 (out, in, enable);
    input [4:0]    in;
    input     enable;
    output [31:0]  out;
    wire [1:0]    w_enable;
 
    // implement using decoder2's and decoder16's
 	decoder2 d2_0(w_enable[1:0], in[4], enable);
    decoder16 d16_0(out[15:0], in[3:0], w_enable[0]);
    decoder16 d16_1(out[31:16], in[3:0], w_enable[1]);

 
 
endmodule // decoder32

module mips_regfile (rd1_data, rd2_data, rd1_regnum, rd2_regnum, 
             wr_regnum, wr_data, writeenable, 
             clock, reset);

    output [31:0]  rd1_data, rd2_data;
    input   [4:0]  rd1_regnum, rd2_regnum, wr_regnum;
    input  [31:0]  wr_data;
    input          writeenable, clock, reset;
 
 	wire [31:0] d_out;
 	wire [31:0] w[0:31];
 	
 	assign w[0][31:0] = 32'b0;

    decoder32 d(d_out, wr_regnum, writeenable);

    register R1(w[1], wr_data, clock, d_out[1], reset);
    register R2(w[2], wr_data, clock, d_out[2], reset);
    register R3(w[3], wr_data, clock, d_out[3], reset);
    register R4(w[4], wr_data, clock, d_out[4], reset);
    register R5(w[5], wr_data, clock, d_out[5], reset);
    register R6(w[6], wr_data, clock, d_out[6], reset);
    register R7(w[7], wr_data, clock, d_out[7], reset);
    register R8(w[8], wr_data, clock, d_out[8], reset);
    register R9(w[9], wr_data, clock, d_out[9], reset);
    register R10(w[10], wr_data, clock, d_out[10], reset);
    register R11(w[11], wr_data, clock, d_out[11], reset);
    register R12(w[12], wr_data, clock, d_out[12], reset);
    register R13(w[13], wr_data, clock, d_out[13], reset);
    register R14(w[14], wr_data, clock, d_out[14], reset);
    register R15(w[15], wr_data, clock, d_out[15], reset);
    register R16(w[16], wr_data, clock, d_out[16], reset);
    register R17(w[17], wr_data, clock, d_out[17], reset);
    register R18(w[18], wr_data, clock, d_out[18], reset);
    register R19(w[19], wr_data, clock, d_out[19], reset);
    register R20(w[20], wr_data, clock, d_out[20], reset);
    register R21(w[21], wr_data, clock, d_out[21], reset);
    register R22(w[22], wr_data, clock, d_out[22], reset);
    register R23(w[23], wr_data, clock, d_out[23], reset);
    register R24(w[24], wr_data, clock, d_out[24], reset);
    register R25(w[25], wr_data, clock, d_out[25], reset);
    register R26(w[26], wr_data, clock, d_out[26], reset);
    register R27(w[27], wr_data, clock, d_out[27], reset);
    register R28(w[28], wr_data, clock, d_out[28], reset);
    register R29(w[29], wr_data, clock, d_out[29], reset);
    register R30(w[30], wr_data, clock, d_out[30], reset);
    register R31(w[31], wr_data, clock, d_out[31], reset);

    mux32v m0(rd1_data, w[0], w[1], w[2], w[3], w[4], w[5], w[6], w[7], w[8], w[9], w[10], w[11], w[12], w[13], w[14], w[15], w[16], w[17], w[18], w[19], w[20], w[21], w[22], w[23], w[24], w[25], w[26], w[27], w[28], w[29], w[30], w[31], rd1_regnum);
    mux32v m1(rd2_data, w[0], w[1], w[2], w[3], w[4], w[5], w[6], w[7], w[8], w[9], w[10], w[11], w[12], w[13], w[14], w[15], w[16], w[17], w[18], w[19], w[20], w[21], w[22], w[23], w[24], w[25], w[26], w[27], w[28], w[29], w[30], w[31], rd2_regnum);


 
 	
    // build a register file!
    
endmodule // mips_regfile

