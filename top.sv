`include "interface.sv"
`include "test.sv"
 
module tbench_top;
   
  // Clock and reset signal declaration
  bit clk;
  bit reset;
   
  // Clock generation
  always #5 clk = ~clk;
   
  // Reset Generation
  initial begin
    reset = 1;
    #5 reset = 0;
  end
   
  // Creating an instance of the interface to connect DUT and test case
  intf i_intf(clk, reset);
   
  // Test case instance, interface handle is passed to test as an argument
  test t1(i_intf);
   
  // DUT instance, interface signals are connected to the DUT ports
  adder DUT (
    .clk(i_intf.clk),
    .reset(i_intf.reset),
    .a(i_intf.a),
    .b(i_intf.b),
    .valid(i_intf.valid),
    .c(i_intf.c)
   );
   
  // Enabling the wave dump
  initial begin
    $dumpfile("dump.vcd"); $dumpvars;
  end
endmodule

