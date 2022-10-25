`timescale 1ns/1ps

module alu(A, B, sel, out);
    input signed [31:0] A, B;
    input [2:0] sel;
    output reg [31:0] out;

    reg [31:0] temp; 

    always @(*) begin
        case (sel)
            3'b000 : out = A & B;
            3'b001 : out = A | B;
            3'b010 : out = A + B;
            3'b110 : out = A - B;
            3'b111 : begin
                temp = A - B;
                out = {{31{1'b0}}, temp[31]};
                end
            default: out = A;
        endcase
    end
endmodule

module tb_alu;
    reg signed [31:0] A, B;
    reg [2:0] sel;
    wire [31:0] out;

    reg [2:0] i;
    reg [1:0] j, k;

    reg [31:0] A_ [1:0];
    reg [31:0] B_ [1:0];
    reg [2:0] op_codes [5:0];

    alu test(A, B, sel, out);

        initial begin
            op_codes[0] = 3'b000;
            op_codes[1] = 3'b001;
            op_codes[2] = 3'b010;
            op_codes[3] = 3'b110;
            op_codes[4] = 3'b111;

            A_[0] = 32'b00000000000000000000000011100000;
            A_[1] = 32'b00000000000000000000110101011101;
            B_[0] = 32'b00000000000000000000000100011010;
            B_[1] = 32'b00000000000000000000000001011001;

            for (j=0;j<2;j++) begin
                A = A_[j];
                for (k=0;k<2;k++) begin
                    B = B_[k];
                    for (i=0;i<5;i++) begin
                        sel = op_codes[i];
                        #10;
                        $display ("%0d test data: Input A is %d, input B is %d, ALUop is %b, result is %d", (10*j+5*k+i+1), A, B, sel, $signed(out));
                    end
                end
            end
        end
endmodule
