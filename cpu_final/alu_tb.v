`timescale 1ns/1ps
`include "alu.v"

module tb_alu;
    reg signed [7:0] A, B;
    reg [2:0] sel;
    wire [7:0] out;
    wire zero;

    reg [2:0] i; 
    reg [1:0] j, k;

    reg [31:0] A_ [1:0];
    reg [31:0] B_ [2:0];
    reg [2:0] op_codes [5:0];

    alu uut(A, B, out, zero, sel);

        initial begin
            op_codes[0] = 3'b000;
            op_codes[1] = 3'b001;
            op_codes[2] = 3'b010;
            op_codes[3] = 3'b011;
            op_codes[4] = 3'b100;

            A_[0] = 8'b00001111;
            A_[1] = 8'b10101010;
            B_[0] = 8'b01011010;
            B_[1] = 8'b10111011;
            B_[2] = 8'b11110000;

            for (j=0;j<2;j++) begin
                A = A_[j];
                for (k=0;k<3;k++) begin
                    B = B_[k];
                    for (i=0;i<5;i++) begin
                        sel = op_codes[i];
                        #10;
                        $display ("%0d test data: A: %d / %8b, B: %d / %8b, ALUop is %b, result is %d / %8b, zero: %1b", (10*j+5*k+i+1), A,A, B,B, sel, $signed(out),$signed(out), zero);
                    end
                end
            end
        end
endmodule