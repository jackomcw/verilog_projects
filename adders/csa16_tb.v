`timescale 1ns/1ps
`include "csa16.v"

module csa_16bit_tb();
    reg [15:0] in1 = 0;
    reg [15:0] in2 = 0;
    reg c_in = 0;
    wire [15:0] w_sum;
    wire c_out;

    csa_16bit csa_adder_tb
        (
            .x(in1),
            .y(in2),
            .cin(c_in),
            .sum(w_sum),
            .cout(c_out)
        );

    initial
        begin
            $dumpfile("csa16_tb.vcd");
            $dumpvars; 
            #10;
            in1 = 16'b0110000110101100; //25004
            in2 = 16'b0000000000111100; //60
            c_in = 0;
            #10;
            $display ("Input 1: %8b | Input 2: %8b | Output: %8b | Carry out: %0b", in1, in2, w_sum, c_out); 
            //result = 0110000111101000 = 25064
 
            #10;
            in1 = 16'b1111111100000000; //65280
            in2 = 16'b0000101011010101; //2773
            c_in = 0;
            #10;
            $display ("Input 1: %8b | Input 2: %8b | Output: %8b | Carry out: %0b", in1, in2, w_sum, c_out); 
            //result: 0000100111010101 = 68053

            #10;
            in1 = 16'b1010101010101010; //43690
            in2 = 16'b0101010101010101; //21845
            c_in = 1;
            #10;
            $display ("Input 1: %8b | Input 2: %8b | Output: %8b | Carry out: %0b", in1, in2, w_sum, c_out); 
            //result = 10000000000000000 = 65536

        end
  
endmodule