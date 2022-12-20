`timescale 1ns/1ps

module math_fn(B, C);
    //input [15:0] A [7:0];
    input [15:0] B;
    output reg [31:0] C;

    reg [15:0] A [7:0];

    integer i;

    initial begin
        A[0] = 8'b00000001;
        A[1] = 8'b00000010;
        A[2] = 8'b00000011;
        A[3] = 8'b00000100;
        A[4] = 8'b00000101;
        A[5] = 8'b00000110;
        A[6] = 8'b00000111;
        A[7] = 8'b00001000;
    end

    always @(B) begin
        C = {32{1'b0}};
        for (i=0; i<8; i=i+1) begin
            #1 C = C + A[i] * B;
            $display("A = %8b | B = %16b | C = %32b = %d", A[i], B, C, C);
        end
    end
endmodule