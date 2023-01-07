`timescale 1ns/1ps
//`include "clk_gen.v"

module registerFile(in, out1, out2, w_addr, r_addr1, r_addr2, write, clk, rst);
    input write, clk, rst;
    input [2:0] w_addr, r_addr1, r_addr2;
    input [7:0] in;
    output [7:0] out1, out2;

    reg [7:0] regFile [7:0];

    integer i;
    always@(rst == 1) begin
        #2 for (i=0; i<8; i=i+1) begin
            regFile[i] = {8{1'b0}};
        end
    end

    always@(negedge clk && in) begin
        if (write == 1 && rst == 0) begin
            $display("writing - R%d - %b", w_addr, in);
            regFile[{{5{1'b0}}, w_addr}] <= in;
        end
    end

    assign #2 out1 = regFile[r_addr1];
    assign #2 out2 = regFile[r_addr2];

endmodule