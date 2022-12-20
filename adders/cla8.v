`timescale 1ns/1ps

module full_adder(input in1, input in2, input cin, output out);
    assign out = in1 ^ in2 ^ cin;
endmodule

module cla_adder_8bits (input [N_BIT-1:0] x, input [N_BIT-1:0] y, input cin, output[N_BIT-1:0] sum, output cout);

    parameter N_BIT = 8;

    //wires
    wire [N_BIT-1:0] P, G, S;
    wire [N_BIT:0] C;

    assign C[0] = cin;

    //full adders
    genvar i;
    generate
        for (i=0; i<N_BIT; i=i+1)
        begin
            full_adder f_a(.in1(x[i]), .in2(y[i]), .cin(C[i]), .out(S[i]));
        end
    endgenerate

    genvar j;
    generate
        for (j=0; j<N_BIT; j=j+1)
        begin
            assign G[j] = x[j] & y[j];
            assign P[j] = x[j] ^ y[j];
            assign C[j+1] = G[j] | (P[j] & C[j]);
        end
    endgenerate

    assign sum = S;
    assign cout = C[N_BIT];

endmodule