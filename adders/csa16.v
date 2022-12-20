`timescale 1ns/1ps

module full_adder(input in1, input in2, input cin, output out);
    assign out = in1 ^ in2 ^ cin;
endmodule

module mux2(input in1, input in2, input sel, output out);
    reg out;

    always @(*) begin
       if (sel == 0)
            out = in1;
        else
            out = in2; 
    end
endmodule

module csa_16bit (input [15:0] x, input [15:0] y, input cin, output [15:0] sum, output cout);
    wire [15:0] P, G, S;
    wire [16:0] C;
    wire BP;
    assign C[0] = cin;

    genvar i;
    generate for (i=0;i<16;i=i+1) begin
           full_adder f_a(.in1(x[i]), .in2(y[i]), .cin(C[i]), .out(S[i]));
        end
    endgenerate

    generate for (i=0;i<16;i=i+1) begin
            assign P[i] = x[i] ^ y[i];
            assign G[i] = x[i] & y[i];
            assign C[i+1] = G[i] | (P[i] & C[i]);
        end
    endgenerate

    assign BP = &P;

    mux2 mux(.in1(C[16]), .in2(C[0]), .sel(BP), .out(cout));

    assign sum = S;

endmodule