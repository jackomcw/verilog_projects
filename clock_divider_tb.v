`timescale 1ns / 1ns

module clock_divider_TB();
  reg clk_fast, reset;
  wire clk_slow;
  reg [31:0] ratio;
  
  clock_divider div(.clk_in(clk_fast), .clk_out(clk_slow), .reset(reset), .ratio(ratio));
  
  initial begin
    clk_fast = 0;
    reset = 0;
  end
  
  always #500 clk_fast = ~clk_fast; //1MHz clk
  
   reg [31:0] slow_count, fast_count;
   
   always@(posedge clk_fast)begin
        fast_count = fast_count + 1;
   end 
   
   always@(posedge clk_slow)begin
        slow_count = slow_count + 1;
   end

  initial begin
    slow_count = 0;
    fast_count = 0;
//    $monitor("clk_fast: %d | ratio = $d | clk_slow = $d", clk_fast, ratio, clk_slow);
    ratio = 10; #100000 //100kHz
    $display("Ratio = %d | fast_count = %d | slow_count = %d", ratio, fast_count, slow_count);
    
    reset = 1; #5
    reset = 0;
    slow_count = 0;
    fast_count = 0;
    ratio = 100; #100000 //10kHz
    $display("Ratio = %d | fast_count = %d | slow_count = %d", ratio, fast_count, slow_count);
    
    reset = 1; #5
    reset = 0;
    slow_count = 0;
    fast_count = 0;
    ratio = 50; #100000 //1kHz
    $display("Ratio = %d | fast_count = %d | slow_count = %d", ratio, fast_count, slow_count);

    $stop;
  end
endmodule
