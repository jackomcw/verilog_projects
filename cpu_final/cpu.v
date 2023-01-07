`timescale 1ns/1ps
`include "alu.v"
`include "8bitReg.v"

/*
                OpCode  Destination   ReadAddr1 ReadAddr2
                31:24   23:16         15:8      7:0

Immediate inst: OpCode  Destination   ReadAddr1 ImmediateVal
Jump inst:      OpCode  -----         -----     RegValAddr|immediateVal
BEQ inst:       OpCode  BranchAddr    RegVal1   RegVal2

OpCode Key:
    b7 write enable
    b6:4 ALU op
    b3 is immediate
    b2 is out2 positive
    b1 is branch
    b0 ZERO
*/

module PC_adder(input [31:0] PC, output reg [31:0] result);
    always@(PC) result = PC+4;
endmodule

module cpu(PC, instruction, clk, rst);
    input [31:0] instruction;
    input clk, rst;
    output reg [31:0] PC;
    wire [31:0] PC_adder_result, PC_next, j_addr, jb_addr;
    wire [7:0] ALU_result, mux1out, mux2out, out1, out2, minusVal;
    wire reset, zero;

    reg [2:0] ALUop, RegReadAddr1, RegReadAddr2, regWriteAddr;
    reg [7:0] immediateVal, in, opcode, b_addr; 
    assign reset = rst;

    registerFile register(in, out1, out2, regWriteAddr, RegReadAddr1, RegReadAddr2, opcode[7], clk, reset);
    //in, out1, out2, w_addr, r_addr1, r_addr2, write, clk, rst
    twos_comp negative_val(out2, minusVal);
    alu alu_unit (mux2out, out1, ALU_result, zero, ALUop); //IN1, IN2, OUT, ZERO, SEL

    //use PC adder to increment PC
    PC_adder PC_inc(PC, PC_adder_result);

    mux2x1_var mux1(minusVal, out2, mux1out, opcode[2]); 
    mux2x1_var mux2(mux1out, immediateVal, mux2out, opcode[3]);

    assign j_addr = {{24{1'b0}}, mux2out};

    //when jump - PC_next is either out2 or imm_val (no negative); when beq, it is potentially writeregaddr; select can be zero as if beq is not zero the value doesn't matter anyway
    mux2x1_var #(.WIDTH(32)) mux_jump(j_addr, {{24{1'b0}}, b_addr}, jb_addr, zero); //jump addr (mux2out) or destination (opcode[23:16]) for next address
    //on beq; ALU operation is performed; if ZERO flag is set, PC_next = mux2out; else, PC_next = PC_adder_result
    mux2x1_var #(.WIDTH(32)) mux_pc(PC_adder_result, jb_addr, PC_next, ((opcode[1] && !zero)|(opcode[0] && zero))); //mux to choose between PC incremented val (normally) or jump inst. address

    always@(rst) begin
        if(rst==1) begin
            PC <= -4; 
            $display("Reset = %b", rst);
        end
    end

    always@(posedge clk) begin
        PC <= PC_next;
        #5 $display("PC: %b | PC_next: %b", PC, PC_next);
    end

    always@(instruction) begin
    //parse instruction
        $display("Instruction: %b", instruction);
        opcode <= instruction[31:24];
        ALUop <= instruction[30:28];
        b_addr <= instruction[23:16];
        regWriteAddr <= instruction[18:16];
        RegReadAddr1 <= instruction[10:8]; //3 bit addressing for 8 addr register
        RegReadAddr2 <= instruction[2:0];
        immediateVal <= instruction[7:0];
        #5
        $display("ALUop: %b, opcode[2](neg) = %b, mux1out %b, mux2out %b, out1 %b, ALU out = %b, zero %b", ALUop, opcode[2], mux1out, mux2out, out1, ALU_result, zero);
    end

    always@(ALU_result) begin
        in <= ALU_result; //reg file input is alu result
    end

endmodule