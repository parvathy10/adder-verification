`include "transaction.sv"

class driver;
    // Variable used to count the number of transactions
    int no_transactions;
   
    // Define a handle for transaction. Since we will be reading a transaction from the mailbox
    transaction trans;
   
    // Creating virtual interface handle
    virtual intf vif;
   
    // Creating mailbox handle
    mailbox #(transaction) gen2driv;
   
    // Constructor
    // Obtain mailbox and virtual interface handles from environment 
    function new(virtual intf vif, mailbox #(transaction) gen2driv);
        this.vif = vif;
        this.gen2driv = gen2driv;
    endfunction
   
    // Reset task, Reset the Interface signals to default/initial values
    task reset();
        // We need to use a task and not a function since we are dealing with time/ events

        wait(vif.reset);     // Wait till we get reset from the interface

        $display("[ DRIVER ] ----- Reset Started -----");
        vif.a <= 0;
        vif.b <= 0;
        vif.valid <= 0;

        wait(!vif.reset);   // Wait till reset is still enabled. Wait for it to be disabled

        $display("[ DRIVER ] ----- Reset Ended   -----");
    endtask
   
    // Main task: drives the transaction items to interface signals
    task main();
        forever begin
            gen2driv.get(trans);    // Get the transaction from mailbox that was filled by generator
            @(posedge vif.clk);     // At rising edge read the value of a, b from generator and give to interface
            vif.valid <= 1;
            vif.a <= trans.a;
            vif.b <= trans.b;
         
            @(posedge vif.clk); // At next rising edge read the value of c from interface and write to transaction
            vif.valid <= 0;
            trans.c <= vif.c;

            @(posedge vif.clk); // At next rising edge, display that a transaction has happened and increment count
            trans.display("[ Driver ]");
            no_transactions++;
        end
    endtask
endclass

