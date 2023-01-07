//from https://esrd2014.blogspot.com/p/barrel-shifter.html

`timescale 1ns/1ps

module mux2x1 (input in1, input in2, output out, input sel);
    reg out;

    always @(*) begin
       if (sel == 1)
            out = in1;
        else
            out = in2; 
    end
endmodule

module barrelShifter(IN, SHIFT, OUT);
    input [7:0] IN;
    input [2:0] SHIFT;
    output [7:0] OUT;

    wire [7:0] ST1, ST2;

    mux2x1 m0_0(1'b0, IN[0], ST1[0], SHIFT[0]);
    mux2x1 m0_1(IN[0], IN[1], ST1[1], SHIFT[0]);
    mux2x1 m0_2(IN[1], IN[2], ST1[2], SHIFT[0]);
    mux2x1 m0_3(IN[2], IN[3], ST1[3], SHIFT[0]);
    mux2x1 m0_4(IN[3], IN[4], ST1[4], SHIFT[0]);
    mux2x1 m0_5(IN[4], IN[5], ST1[5], SHIFT[0]);
    mux2x1 m0_6(IN[5], IN[6], ST1[6], SHIFT[0]);
    mux2x1 m0_7(IN[6], IN[7], ST1[7], SHIFT[0]);
    mux2x1 m1_0(1'b0, ST1[0], ST2[0], SHIFT[1]);
    mux2x1 m1_1(1'b0, ST1[1], ST2[1], SHIFT[1]);
    mux2x1 m1_2(ST1[0], ST1[2], ST2[2], SHIFT[1]);
    mux2x1 m1_3(ST1[1], ST1[3], ST2[3], SHIFT[1]);
    mux2x1 m1_4(ST1[2], ST1[4], ST2[4], SHIFT[1]);
    mux2x1 m1_5(ST1[3], ST1[5], ST2[5], SHIFT[1]);
    mux2x1 m1_6(ST1[4], ST1[6], ST2[6], SHIFT[1]);
    mux2x1 m1_7(ST1[5], ST1[7], ST2[7], SHIFT[1]);
    mux2x1 m2_0(1'b0, ST2[0], OUT[0], SHIFT[2]);
    mux2x1 m2_1(1'b0, ST2[1], OUT[1], SHIFT[2]);
    mux2x1 m2_2(1'b0, ST2[2], OUT[2], SHIFT[2]);
    mux2x1 m2_3(1'b0, ST2[3], OUT[3], SHIFT[2]);
    mux2x1 m2_4(ST2[0], ST2[4], OUT[4], SHIFT[2]);
    mux2x1 m2_5(ST2[1], ST2[5], OUT[5], SHIFT[2]);
    mux2x1 m2_6(ST2[2], ST2[6], OUT[6], SHIFT[2]);
    mux2x1 m2_7(ST2[3], ST2[7], OUT[7], SHIFT[2]);

endmodule