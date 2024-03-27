module adder(
  input clk,
  input 	reset,
  input  [3:0] a	,
  input  [3:0] b	,
  input        valid,
  output [6:0] c  		); 
  
  reg [6:0] tmp_c;
  
always @(posedge reset or posedge clk) 
 begin
   if(reset) 
   tmp_c <= 0;
   else
       if (valid)    
            tmp_c <= a + b;
       else tmp_c <= tmp_c;
  end

  assign c = tmp_c;
endmodule
