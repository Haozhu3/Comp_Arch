module pipelined_machine(clk, reset);
    input        clk, reset;

    wire [31:0]  PC;
    wire [31:2]  next_PC, PC_plus4_IF, PC_plus4_DE, PC_target;
    wire [31:0]  inst_IF, inst_DE;

    wire [31:0]  imm = {{ 16{inst_DE[15]} }, inst_DE[15:0] };  // sign-extended immediate
    wire [4:0]   rs = inst_DE[25:21];
    wire [4:0]   rt = inst_DE[20:16];
    wire [4:0]   rd = inst_DE[15:11];
    wire [5:0]   opcode = inst_DE[31:26];
    wire [5:0]   funct = inst_DE[5:0];

    wire [4:0]   wr_regnum, wr_regnum_MW;
    wire [2:0]   ALUOp;

    wire         RegWrite, RegWrite_MW, BEQ, ALUSrc, MemRead, MemRead_MW, MemWrite, MemWrite_MW,  MemToReg, MemToReg_MW, RegDst, forwardA, forwardB;
    wire         PCSrc, zero, stall, flush, guard;
    wire [31:0]  rd1_data, rd2_data, B_data, alu_out_data_DE, alu_out_data_MW, load_data, wr_data, rs_select, rt_select, rt_select_MW;


    //PIPE IF/DE
    register #(32) inst_fd_pipe(inst_DE, inst_IF, clk, ~stall, reset|flush);
    register #(30) PC_plus4_fd_pipe(PC_plus4_DE, PC_plus4_IF, clk, ~stall, reset|flush);
    //PIPE DE/MW
    register #(5) wr_regnum_dm_pipe(wr_regnum_MW, wr_regnum, clk, 1'b1, stall|reset|flush);
    register #(32) alu_out_data_dm_pipe(alu_out_data_MW, alu_out_data_DE, clk, 1'b1, stall|reset|flush);
    register #(1) RegWrite_dm_pipe(RegWrite_MW, RegWrite, clk, 1'b1, stall|reset|flush);
    register #(1) MemRead_dm_pipe(MemRead_MW, MemRead, clk, 1'b1, stall|reset|flush);
    register #(1) MemWrite_dm_pipe(MemWrite_MW, MemWrite, clk, 1'b1, stall|reset|flush);
    register #(1) MemToReg_dm_pipe(MemToReg_MW, MemToReg, clk, 1'b1, stall|reset|flush);
    register #(32) rt_select_dm_pipe(rt_select_MW, rt_select, clk, 1'b1, stall|reset|flush);

    //forwarding
    assign forwardA = (wr_regnum_MW == rs) & RegWrite_MW & ~guard;
    assign forwardB = (wr_regnum_MW == rt) & RegWrite_MW & ~guard;
    mux2v #(32) mux_forwardA(rs_select, rd1_data, alu_out_data_MW, forwardA);
    mux2v #(32) mux_forwardB(rt_select, rd2_data, alu_out_data_MW, forwardB);

    assign stall = (MemRead_MW == 1) && ( (rt == wr_regnum_MW) || (rs == wr_regnum_MW) );

    assign flush = PCSrc;

    assign guard = (rs == 0) | (rt == 0);
    // DO NOT comment out or rename this module
    // or the test bench will break
    register #(30, 30'h100000) PC_reg(PC[31:2], next_PC[31:2], clk, ~stall, reset);

    assign PC[1:0] = 2'b0;  // bottom bits hard coded to 00
    adder30 next_PC_adder(PC_plus4_IF, PC[31:2], 30'h1);
    adder30 target_PC_adder(PC_target, PC_plus4_DE, imm[29:0]);
    mux2v #(30) branch_mux(next_PC, PC_plus4_IF, PC_target, PCSrc);
    assign PCSrc = BEQ & zero;

    // DO NOT comment out or rename this module
    // or the test bench will break
    instruction_memory imem(inst_IF, PC[31:2]);

    mips_decode decode(ALUOp, RegWrite, BEQ, ALUSrc, MemRead, MemWrite, MemToReg, RegDst,
                      opcode, funct);

    // DO NOT comment out or rename this module
    // or the test bench will break
    regfile rf (rd1_data, rd2_data,
               rs, rt, wr_regnum_MW, wr_data,
               RegWrite_MW, clk, reset);

    mux2v #(32) imm_mux(B_data, rt_select, imm, ALUSrc);
    alu32 alu(alu_out_data_DE, zero, ALUOp, rs_select, B_data);

    // DO NOT comment out or rename this module
    // or the test bench will break
    data_mem data_memory(load_data, alu_out_data_MW, rt_select_MW, MemRead_MW, MemWrite_MW, clk, reset);

    mux2v #(32) wb_mux(wr_data, alu_out_data_MW, load_data, MemToReg_MW);
    mux2v #(5) rd_mux(wr_regnum, rt, rd, RegDst);

endmodule // pipelined_machine
