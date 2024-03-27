`include "environment.sv"

module test(intf intf);
   
  // Declaring environment instance
  environment env;
   
  initial begin
    // Creating environment
    env = new(intf);
    
    // Setting the packet_count of generator to generate 10 packets
    env.gen.packet_count = 10;
    
    // Calling ?run? of env, it in turn calls generator and driver main tasks.
    env.run();
  end
endmodule

