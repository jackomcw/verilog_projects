`timescale 1ns/1ps
`include "cpu.v"

/*
                OpCode  Destination   ReadAddr1 ReadAddr2
                31:24   23:16         15:8      7:0

Immediate inst: OpCode  Destination ReadAddr1   ImmediateVal
Jump inst:      OpCode  -----         -----     RegValAddr|immediateVal

OpCode Key:
    b7 write enable
    b6:4 ALU op
    b3 is immediate
    b2 is out2 positive
    b1 is branch
    b0 ZERO
*/

module cpu_tb(); 
    reg clk, rst;
    wire [31:0] PC;
    reg [31:0] instruction;
    reg [7:0] opcodes [15:0];

    //instruction memory: 8bit wide, up to 2^32 locations
    reg [7:0] instruction_mem [127:0];
    
    integer i;
    
    initial begin
        $display("cpu_tb here");
        clk = 0;
        for (i=0; i<128; i=i+1) instruction_mem[i] = {8{1'b0}}; 
        forever begin
            #5 clk = ~clk;
            $display("clk = %b", clk);
            //clk_counter = clk_counter + 1
        end
    end

    always@(PC) begin
        instruction = {
            instruction_mem[PC+3],
            instruction_mem[PC+2],
            instruction_mem[PC+1],
            instruction_mem[PC]
        };
        //$display("Instruction: %b", instruction);
    end

    cpu cpu_test(PC, instruction, clk, rst);

    initial begin

        $display("R1 = %8b", cpu_test.register.regFile[1]);

        opcodes[0]  = 8'b1000_1100; //ld
        opcodes[1]  = 8'b1000_0100; //mov
        opcodes[2]  = 8'b1001_0100; //add
        opcodes[3]  = 8'b1001_1100; //addi
        opcodes[4]  = 8'b1001_0000; //sub
        opcodes[5]  = 8'b1001_1000; //subi
        opcodes[6]  = 8'b1010_0100; //and
        opcodes[7]  = 8'b1011_0100; //or
        opcodes[8]  = 8'b0000_0110; //jmp
        opcodes[9]  = 8'b0000_1110; //jmpi
        opcodes[10] = 8'b0001_0011; //beq
        
        for (i=11; i<16; i=i+1) opcodes[i] = {32{1'b0}};

        /*
            Desired pseudocode:
        0:  store 10 in R1
            r1 = r1 + #10
            store 15 in R2
            R3 = R1 + R2
            R3 = R3 - #40
            R1 = 64
            jump to addr in R1
        64: store val in R3 in R2
            beq R2 and R3 to 30
        */

        // instruction_mem[3:0]   = {opcodes[0], 8'd1, 8'dx, 8'd10};
        //10001100 00000001 00000000 00001010
        instruction_mem[3] = opcodes[0];
        instruction_mem[2] = 8'd1;
        instruction_mem[1] = 8'd0;
        instruction_mem[0] = 8'd10;

        // instruction_mem[7:4]   = {opcodes[3], 8'd1, 8'd1, 8'd10};
        //10011100 00000001 00000001 00001010
        instruction_mem[7] = opcodes[3];
        instruction_mem[6] = 8'd1;
        instruction_mem[5] = 8'd1;
        instruction_mem[4] = 8'd10;

        // instruction_mem[11:8]  = {opcodes[0], 8'd2, 8'dx, 8'd15};
        // 10001100000000100000000000001111
        instruction_mem[11] = opcodes[0];
        instruction_mem[10]  = 8'd2;
        instruction_mem[9]  = 8'd0;
        instruction_mem[8]  = 8'd15;

        // instruction_mem[15:12] = {opcodes[2], 8'd3, 8'd1, 8'd2};
        //10010100 00000011 00000001 00000010
        instruction_mem[15] = opcodes[2];
        instruction_mem[14] = 8'd3;
        instruction_mem[13] = 8'd1;
        instruction_mem[12] = 8'd2;

        // instruction_mem[19:16] = {opcodes[5], 8'd3, 8'd3, 8'd40};
        //10011000 00000011 00000011 00101000
        instruction_mem[19] = opcodes[5];
        instruction_mem[18] = 8'd3;
        instruction_mem[17] = 8'd3;
        instruction_mem[16] = -8'd40;

        // instruction_mem[23:20] = {opcodes[0], 8'd1, 8'dx, 8'd64};
        //10001100 00000001 00000000 01000000
        instruction_mem[23] = opcodes[0];
        instruction_mem[22] = 8'd1;
        instruction_mem[21] = 8'd0;
        instruction_mem[20] = 8'd64;

        // instruction_mem[27:24] = {opcodes[8], 8'dx, 8'dx, 8'd1};
        //00000110 00000000 00000000 00000001
        instruction_mem[27] = opcodes[8];
        instruction_mem[26] = 8'd0;
        instruction_mem[25] = 8'd0;
        instruction_mem[24] = 8'd1;

        // instruction_mem[67:64] = {opcodes[1], 8'd2, 8'dx, 8'd3};
        //z10000100 00000010 00000001 00000011
        instruction_mem[67] = opcodes[1]; 
        instruction_mem[66] = 8'd2;
        instruction_mem[65] = 8'd1;
        instruction_mem[64] = 8'd3;

        // instruction_mem[71:68] = {opcodes[10], 8'dx, 8'd2, 8'd3};
        //00010011 00011110 00000010 00000011
        instruction_mem[71] = opcodes[10];
        instruction_mem[70] = 8'd30;
        instruction_mem[69] = 8'd2;
        instruction_mem[68] = 8'd3;

        rst = 1;
        #1 rst = 0;

        #100
        $finish;
    end

endmodule