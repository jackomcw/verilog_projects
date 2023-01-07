//from https://studentsxstudents.com/simple-8-bit-processor-design-and-verilog-implementation-part-1-8735fac284b

//add, sub, and, or, mov, loadi, j, and beq
`timescale 1ns/1ps
`include "barrelShifter.v"

//OpCode    Destination In1     In2
//31:24     23:16       15:8    7:0

module twos_comp(input [7:0] in, output reg [7:0] result);
    always@(*) begin
        result <= ~in+1;
    end
endmodule

module mux2x1_var (in1, in2, out, sel);
    parameter WIDTH = 8;
    input [WIDTH-1:0] in1, in2;
    input sel;
    output reg [WIDTH-1:0] out;

    always @(*) begin
       if (sel == 1)
            out = in2;
        else
            out = in1; 
    end
endmodule

module alu(IN1, IN2, OUT, ZERO, SEL);
    input [7:0] IN1, IN2;
    input [2:0] SEL;
    input ACT;
    output reg [7:0] OUT;
    output reg ZERO;

    wire [7:0] RshiftResult;

    initial begin
      OUT = {7{1'b0}};
    end

    barrelShifter RightLogicalShifter(IN1, IN2[7:5], RshiftResult); //input to be shifted, shift amount, output reg

    always @(IN1, IN2, SEL) begin
        case(SEL)
            3'b000: #2 OUT = IN1; //mov and ld
            3'b001: #2 OUT = IN1 + IN2; //add and sub
            3'b010: #2 OUT = IN1 & IN2; //AND and sub
            3'b011: #2 OUT = IN1 | IN2; //OR and sub
            3'b100: #2 OUT = RshiftResult; 
            // 3'b101:
            // 3'b110:
            // 3'b111:
            default: OUT = {8{1'b0}};
        endcase
    end
    //zero bit
    always@(OUT) begin
        ZERO = ~|(OUT);
    end
endmodule