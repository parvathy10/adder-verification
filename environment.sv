`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"

class environment;
    // Generator and driver instance
    generator gen;
    driver    driv;
    
    // Mailbox handle
    mailbox #(transaction) gen2driv;
    
    // Virtual inerface  
    virtual intf vif;
   
    // Constructor
    function new(virtual intf vif);
        this.vif = vif;
        
        // Creating the mailbox (Same handle will be shared across generator and driver)
        gen2driv = new();
        
        // Creating generator and driver
        gen  = new(gen2driv);
        driv = new(vif, gen2driv);
    endfunction     // End of constructor

    // Generator and driver activity
    task pre_test();
        driv.reset();
    endtask
   
    task test();
        fork
            gen.main();
            driv.main();
        join_any    // As soon as generate is finished, go to post_test and wait for packet generation ending 
    endtask
   
    task post_test();
        // Check if PacketGenerationEnded is triggered
        // Replace 'PacketGenerationEnded' with the correct member of the generator class
        wait(gen.PacketGenerationEnded.triggered);
        
        // Check if repeat_count matches the number of transactions in the driver
        // Replace 'repeat_count' with the correct member of the generator class
        wait(gen.repeat_count == driv.no_transactions);
    endtask 

    // Run all tasks
    task run();
        pre_test();
        test();
        post_test();
        $finish;
    endtask
endclass

