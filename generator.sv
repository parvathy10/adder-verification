`include "transaction.sv"

class generator;
    // Declaring transaction class 
    transaction trans;
  
    // To specify the number of packets to generate
    int packet_count;
  
    // Mailbox, to generate and send the packet to the driver (this mailbox has to be passed from environment)
    mailbox #(transaction) gen2driv;
  
    // Event, to indicate the end of transaction generation
    event PacketGenerationEnded;
    
    // Field to keep track of the number of generated packets
    int repeat_count;
  
    // Constructor
    // Getting the mailbox handle from the environment. The environment class has the mailbox since the transaction packet is
    // to be shared between the generator and driver
    function new(mailbox #(transaction) gen2driv);
        this.gen2driv = gen2driv;
        repeat_count = 0; // Initialize the counter
    endfunction
  
    // Main task: To generate (create and randomize) the required number of transaction packets and 
    // put them into the mailbox
    task main();
        // We need to use a task and not a function since we are dealing with time/events

        repeat (packet_count) begin
            trans = new();
            // Manually assign values to transaction properties
            trans.a = $urandom;
            trans.b = $urandom;
            trans.c = $urandom;
            
            // Display the generated transaction
            trans.display("[ Generator ]");
            
            // Put in mailbox for the driver to see
            gen2driv.put(trans); 
            
            repeat_count++; // Increment the counter
        end

        -> PacketGenerationEnded; // Triggering indicates the end of generation
    endtask
endclass

